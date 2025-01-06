import 'package:flutter/material.dart';
import 'register.dart';
import 'package:bus_tracking_system/screens/navigation.dart';
import 'package:bus_tracking_system/screens/user_storage_service.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Tracking System',
      theme: ThemeData(
        primaryColor: Color(0xFF2196F3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2196F3),
          secondary: Color(0xFF1976D2),
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1565C0),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class OTPService {
  static const String _otpKey = 'current_otp';
  static const String _otpExpiryKey = 'otp_expiry';
  static const int _otpLength = 6;
  static const int _otpValidityMinutes = 5;

  final Random _random = Random.secure();

  Future<String> generateOTP(String phoneNumber) async {
    String otp = '';
    for (int i = 0; i < _otpLength; i++) {
      otp += _random.nextInt(10).toString();
    }

    final prefs = await SharedPreferences.getInstance();
    final expiryTime =
        DateTime.now().add(Duration(minutes: _otpValidityMinutes));

    await prefs.setString('${_otpKey}_$phoneNumber', otp);
    await prefs.setString(
        '${_otpExpiryKey}_$phoneNumber', expiryTime.toIso8601String());

    return otp;
  }

  Future<bool> verifyOTP(String phoneNumber, String enteredOTP) async {
    final prefs = await SharedPreferences.getInstance();
    final storedOTP = prefs.getString('${_otpKey}_$phoneNumber');
    final expiryTimeStr = prefs.getString('${_otpExpiryKey}_$phoneNumber');

    if (storedOTP == null || expiryTimeStr == null) {
      return false;
    }

    final expiryTime = DateTime.parse(expiryTimeStr);
    if (DateTime.now().isAfter(expiryTime)) {
      await clearOTP(phoneNumber);
      return false;
    }

    bool isValid = storedOTP == enteredOTP;
    if (isValid) {
      await clearOTP(phoneNumber);
    }

    return isValid;
  }

  Future<void> clearOTP(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_otpKey}_$phoneNumber');
    await prefs.remove('${_otpExpiryKey}_$phoneNumber');
  }

  Future<int> getRemainingTime(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTimeStr = prefs.getString('${_otpExpiryKey}_$phoneNumber');

    if (expiryTimeStr == null) {
      return 0;
    }

    final expiryTime = DateTime.parse(expiryTimeStr);
    final remaining = expiryTime.difference(DateTime.now());
    return remaining.inSeconds > 0 ? remaining.inSeconds : 0;
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final OTPService _otpService = OTPService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _logoTapCount = 0;
  final int _requiredTapsForAdmin = 5;
  bool showAdminLogin = false;
  Timer? _tapResetTimer;
  Timer? _adminLoginTimer;
  Timer? _otpTimer;
  bool isOtpSent = false;
  int _remainingTime = 0;
  bool isResendEnabled = true;
  int resendCooldown = 60;
  Timer? _resendCooldownTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    phoneController.dispose();
    otpController.dispose();
    _tapResetTimer?.cancel();
    _adminLoginTimer?.cancel();
    _otpTimer?.cancel();
    _resendCooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(),
                      SizedBox(height: 40),
                      _buildLoginForm(),
                      SizedBox(height: 24),
                      _buildGuestOption(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _tapResetTimer?.cancel();

            setState(() {
              _logoTapCount++;

              _tapResetTimer = Timer(Duration(seconds: 3), () {
                setState(() {
                  _logoTapCount = 0;
                });
              });

              if (_logoTapCount == _requiredTapsForAdmin) {
                _adminLoginTimer = Timer(Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                  _showAdminLoginDialog();
                });
              } else if (_logoTapCount > _requiredTapsForAdmin) {
                _logoTapCount = 0;
                _adminLoginTimer?.cancel();
                _tapResetTimer?.cancel();
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }
            });
          },
          child: Icon(
            Icons.directions_bus_rounded,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Welcome Back',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(height: 8),
        Text(
          'Bus Tracking System',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 16),
        _buildRegisterOption(),
      ],
    );
  }

  void _showAdminLoginDialog() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AdminLoginScreen()),
    );
  }

  Widget _buildRegisterOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          ),
          child: Text(
            'Register here',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildInputField(
            controller: phoneController,
            hint: 'Enter phone number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          if (isOtpSent) ...[
            _buildInputField(
              controller: otpController,
              hint: 'Enter OTP',
              icon: Icons.lock_outline,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'OTP expires in: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                TextButton(
                  onPressed: isResendEnabled ? _resendOtp : null,
                  child: Text(
                    isResendEnabled
                        ? 'Resend OTP'
                        : 'Resend in ${resendCooldown}s',
                    style: TextStyle(
                      color: isResendEnabled
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 24),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isOtpSent ? 'Verify OTP' : 'Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildGuestOption() {
    return TextButton(
      onPressed: _navigateToHome,
      child: Text(
        'Continue as Guest',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      String otp = await _otpService.generateOTP(phoneController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your OTP is: $otp'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
        ),
      );

      setState(() {
        isOtpSent = true;
        _remainingTime = 300;
      });

      _startOtpTimer();
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
          isOtpSent = false;
          _otpService.clearOTP(phoneController.text);
        }
      });
    });
  }

  Future<void> _resendOtp() async {
    if (!isResendEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please wait ${resendCooldown} seconds before requesting a new OTP'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    await _otpService.clearOTP(phoneController.text);

    String newOtp = await _otpService.generateOTP(phoneController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your new OTP is: $newOtp'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    setState(() {
      _remainingTime = 300;
      isResendEnabled = false;
    });

    _startResendCooldown();

    _startOtpTimer();
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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      if (isOtpSent) {
        bool isValid = await _otpService.verifyOTP(
          phoneController.text,
          otpController.text,
        );

        if (isValid) {
          final storageService = UserStorageService();
          final userData =
              await storageService.getUserDataByPhone(phoneController.text);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userId', phoneController.text);

          if (userData != null) {
            if (userData['email'] != null) {
              await prefs.setString('userEmail', userData['email']);
            } else {
              await prefs.setString(
                  'userEmail', '${phoneController.text}@default.com');
            }

            await storageService.saveUserData(
              phoneNumber: phoneController.text,
              email: userData['email'] ?? '',
              username: userData['username'] ?? '',
              profilePicPath: userData['profilePicPath'],
            );
          } else {
            await prefs.setString(
                'userEmail', '${phoneController.text}@default.com');

            await storageService.saveUserData(
              phoneNumber: phoneController.text,
              email: '',
              username: '',
              profilePicPath: null,
            );
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid OTP. Please try again.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        await _sendOtp();
      }
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
    );
  }
}
