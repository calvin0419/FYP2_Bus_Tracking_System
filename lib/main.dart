import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/register.dart';
import 'screens/login.dart';
import 'screens/profile.dart';
import 'screens/bus_status.dart';
import 'screens/bus_info.dart';
import 'screens/contact_us.dart';
import 'screens/scan.dart';
import 'screens/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/admin_dashboard.dart';
import 'dart:async';
import 'package:bus_tracking_system/services/bus_status_storage.dart';
import 'screens/bus_list.dart';
import 'package:provider/provider.dart';
import 'package:bus_tracking_system/services/bus_status_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BusStatusStorage.database;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BusStatusProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Tracking System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BottomNavigationScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/list': (context) => BusListScreen(),
        '/status': (context) => BusStatusScreen(),
        '/info': (context) =>
            BusInfoScreen(routeId: '', busId: '', licensePlate: ''),
        '/contact': (context) => ContactUsScreen(),
        '/scan': (context) => ScanScreen(),
      },
    );
  }
}
