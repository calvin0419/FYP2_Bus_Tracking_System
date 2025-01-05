import 'package:flutter/material.dart';
import 'package:bus_tracking_system/screens/admin_dashboard.dart';

class AdminLoginScreen extends StatelessWidget {
  final TextEditingController adminUsernameController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: adminUsernameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: adminPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = adminUsernameController.text;
                String password = adminPasswordController.text;
                _handleAdminLogin(context, username, password);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAdminLogin(BuildContext context, String username, String password) {
    const String ADMIN_USERNAME = 'admin';
    const String ADMIN_PASSWORD = 'admin123';

    if (username == ADMIN_USERNAME && password == ADMIN_PASSWORD) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid admin credentials'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 