import 'package:flutter/material.dart';
import 'register.dart';
import 'package:bus_tracking_system/screens/navigation.dart';
import 'package:bus_tracking_system/screens/user_storage_service.dart';
import 'dart:async';
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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _logoTapCount = 0;
  final int _requiredTapsForAdmin = 5;
  bool showAdminLogin = false;
  Timer? _tapResetTimer;
  Timer? _adminLoginTimer;
  bool isOtpSent = false;

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
                _adminLoginTimer = Timer(Duration(seconds: 5), () {
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _resendOtp,
                child: Text('Resend OTP'),
              ),
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

  void _sendOtp() {
    setState(() {
      isOtpSent = true;
    });
  }

  void _resendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP has been resent to your phone.'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      if (isOtpSent) {
        if (otpController.text == '1234') {
          final storageService = UserStorageService();

          final userData =
              await storageService.getUserDataByPhone(phoneController.text);

          if (userData != null) {
            await storageService.saveUserData(
              phoneNumber: phoneController.text,
              email: userData['email'] ?? '',
              username: userData['username'] ?? '',
              profilePicPath: userData['profilePicPath'],
            );
          } else {
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
        _sendOtp();
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
