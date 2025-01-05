import 'dart:io';
import 'package:flutter/material.dart';
import 'profile_update.dart';
import 'login.dart';
import 'register.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class UserStorageService {
  static final UserStorageService _instance = UserStorageService._internal();
  final _storage = const FlutterSecureStorage();

  factory UserStorageService() {
    return _instance;
  }

  UserStorageService._internal();

  Future<void> saveUserData({
    required String email,
    required String username,
    required String phoneNumber,
    String? profilePicPath,
  }) async {
    final userData = {
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'profilePicPath': profilePicPath,
      'isLoggedIn': true,
    };

    await _storage.write(
      key: 'userData',
      value: json.encode(userData),
    );
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: 'userData');
    if (data != null) {
      return json.decode(data);
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final data = await getUserData();
    return data?['isLoggedIn'] ?? false;
  }

  Future<void> updateField(String field, String value) async {
    final data = await getUserData();
    if (data != null) {
      data[field] = value;
      await _storage.write(
        key: 'userData',
        value: json.encode(data),
      );
    }
  }

  Future<void> clearData() async {
    await _storage.delete(key: 'userData');
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  String email = '';
  String username = '';
  String phoneNumber = '';
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final storageService = UserStorageService();
    final userData = await storageService.getUserData();

    setState(() {
      if (userData != null) {
        isLoggedIn = true;
        email = userData['email'] ?? '';
        username = userData['username'] ?? '';
        phoneNumber = userData['phoneNumber'] ?? '';
        String? profilePicUrl = userData['profilePicPath'];
        if (profilePicUrl != null) {
          _profileImage = File(profilePicUrl);
        }
      } else {
        isLoggedIn = false;
      }
    });
  }

  void _navigateToProfileUpdate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileUpdateScreen()),
    ).then((_) {
      _checkLoginStatus();
    });
  }

  void _logout() async {
    final storageService = UserStorageService();
    await storageService.clearData();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
      ),
      body: isLoggedIn ? _buildLoggedInProfile() : _buildGuestProfile(),
    );
  }

  Widget _buildLoggedInProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                const SizedBox(height: 0),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Icon(Icons.person,
                                  size: 60, color: Colors.grey[300])
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _navigateToProfileUpdate,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoCard(
                  'Contact Information',
                  [
                    {'icon': Icons.email, 'title': 'Email', 'value': email},
                    {
                      'icon': Icons.phone,
                      'title': 'Phone',
                      'value': phoneNumber
                    },
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _navigateToProfileUpdate,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.logout, color: Colors.red),
                    label: Text('Logout', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.red),
                    ),
                    onPressed: _logout,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Map<String, dynamic>> items) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Icon(item['icon'] as IconData, color: Colors.grey),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                item['value'] as String,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestProfile() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 80,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.account_circle,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 28),
            Text(
              'Welcome to Bus Track App',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              'Sign in or create an account to manage your profile',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 28),
            _buildFeatureCard(
              Icons.person,
              'Personal Profile',
              'Create and customize your profile',
            ),
            SizedBox(height: 12),
            _buildFeatureCard(
              Icons.security,
              'Secure Account',
              'Your data is safe with us',
            ),
            SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: Text('Login to Your Account'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Icon(Icons.person_add),
                label: Text('Create New Account'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Theme.of(context).primaryColor),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
