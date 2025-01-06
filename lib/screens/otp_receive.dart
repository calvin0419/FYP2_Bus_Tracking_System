import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bus_tracking_system/screens/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

class OtpReceiveScreen extends StatefulWidget {
  final String phoneNumber;

  OtpReceiveScreen({super.key, required this.phoneNumber});

  @override
  _OtpReceiveScreenState createState() => _OtpReceiveScreenState();
}

class _OtpReceiveScreenState extends State<OtpReceiveScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  Timer? _otpTimer;
  Timer? _resendCooldownTimer;
  int _remainingTime = 300;
  bool isResendEnabled = false;
  int resendCooldown = 60;
  bool _hasShownExpiryMessage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateAndShowOTP();
    });
    _startOtpTimer();
    _startResendCooldown();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _otpTimer?.cancel();
    _resendCooldownTimer?.cancel();
    super.dispose();
  }

  // Keeping all the existing helper methods unchanged
  String _generateOTP() {
    final Random _random = Random.secure();
    String otp = '';
    for (int i = 0; i < 6; i++) {
      otp += _random.nextInt(10).toString();
    }
    return otp;
  }

  Future<void> _generateAndShowOTP() async {
    String newOtp = _generateOTP();
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = DateTime.now().add(Duration(minutes: 5));

    await prefs.setString('current_otp_${widget.phoneNumber}', newOtp);
    await prefs.setString(
        'otp_expiry_${widget.phoneNumber}', expiryTime.toIso8601String());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your OTP is: $newOtp'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
  }

  void _startOtpTimer() {
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _otpTimer?.cancel();
          _clearOTP();
        }
      });
    });
  }

  void _startResendCooldown() {
    _resendCooldownTimer?.cancel();
    _resendCooldownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (resendCooldown > 0) {
          resendCooldown--;
        } else {
          isResendEnabled = true;
          resendCooldown = 60;
          _resendCooldownTimer?.cancel();
        }
      });
    });
  }

  Future<void> _clearOTP() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_otp_${widget.phoneNumber}');
    await prefs.remove('otp_expiry_${widget.phoneNumber}');
    _hasShownExpiryMessage = false;
  }

  Future<void> _resendOtp() async {
    if (!isResendEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please wait ${resendCooldown} seconds before requesting a new OTP'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await _clearOTP();
    await _generateAndShowOTP();

    String newOtp = _generateOTP();

    final prefs = await SharedPreferences.getInstance();
    final expiryTime = DateTime.now().add(Duration(minutes: 5));
    await prefs.setString('current_otp_${widget.phoneNumber}', newOtp);
    await prefs.setString(
        'otp_expiry_${widget.phoneNumber}', expiryTime.toIso8601String());

    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();

    setState(() {
      _remainingTime = 300;
      isResendEnabled = false;
      resendCooldown = 60;
      _hasShownExpiryMessage = false;
    });

    _startOtpTimer();
    _startResendCooldown();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your new OTP is: $newOtp'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _verifyOtp() async {
    String enteredOtp = _controllers.map((c) => c.text).join();

    if (enteredOtp.length != 6) return;

    final prefs = await SharedPreferences.getInstance();
    final storedOTP = prefs.getString('current_otp_${widget.phoneNumber}');
    final expiryTimeStr = prefs.getString('otp_expiry_${widget.phoneNumber}');

    if (storedOTP == null || expiryTimeStr == null) {
      if (!_hasShownExpiryMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP has expired. Please request a new one.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _hasShownExpiryMessage = true;
      }
      return;
    }

    final expiryTime = DateTime.parse(expiryTimeStr);
    if (DateTime.now().isAfter(expiryTime)) {
      if (!_hasShownExpiryMessage) {
        await _clearOTP();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP has expired. Please request a new one.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _hasShownExpiryMessage = true;
      }
      return;
    }

    if (enteredOtp == storedOTP) {
      await _clearOTP();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('OTP verified successfully'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', widget.phoneNumber);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Invalid OTP'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double availableWidth = screenWidth - 48;
    double boxWidth = (availableWidth - (5 * 8)) / 6;

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Verify Phone',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.phone_android_rounded,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verification Code Sent',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.phoneNumber,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => Container(
                            width: boxWidth,
                            height: boxWidth * 1.2,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _focusNodes[index].hasFocus
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  _focusNodes[index + 1].requestFocus();
                                }
                                if (value.isNotEmpty && index == 5) {
                                  _verifyOtp();
                                }
                              },
                              onTap: () {
                                if (_controllers[index].text.isEmpty) {
                                  for (int i = 0; i < index; i++) {
                                    if (_controllers[i].text.isEmpty) {
                                      _focusNodes[i].requestFocus();
                                      return;
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 18,
                                color: _remainingTime < 60
                                    ? Colors.red
                                    : Colors.black54,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Code expires in ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: _remainingTime < 60
                                      ? Colors.red
                                      : Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: double.infinity,
                        height: 54,
                        margin: EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
                          onPressed: _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Verify Code',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: isResendEnabled ? _resendOtp : null,
                          style: TextButton.styleFrom(
                            foregroundColor:
                                isResendEnabled ? Colors.blue : Colors.grey,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                isResendEnabled
                                    ? 'Resend Code'
                                    : 'Resend Code (${resendCooldown}s)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
