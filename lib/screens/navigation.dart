import 'package:bus_tracking_system/screens/home.dart';
import 'package:flutter/material.dart';
import 'bus_status.dart';
import 'contact_us.dart';
import 'profile.dart';
import 'bus_list.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    BusListScreen(),
    BusStatusScreen(),
    ContactUsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  selectedItemColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Colors.grey,
                  showUnselectedLabels: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                  items: [
                    _buildNavItem(
                      icon: Icons.home_rounded,
                      activeIcon: Icons.home_rounded,
                      label: 'Home',
                    ),
                    _buildNavItem(
                      icon: Icons.directions_bus_outlined,
                      activeIcon: Icons.directions_bus_rounded,
                      label: 'Bus',
                    ),
                    _buildNavItem(
                      icon: Icons.bus_alert_outlined,
                      activeIcon: Icons.bus_alert_rounded,
                      label: 'Bus Status',
                      isCenter: true,
                    ),
                    _buildNavItem(
                      icon: Icons.contact_support_outlined,
                      activeIcon: Icons.contact_support_rounded,
                      label: 'Contact',
                    ),
                    _buildNavItem(
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    bool isCenter = false,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          shape: isCenter ? BoxShape.circle : BoxShape.rectangle,
          color: isCenter && _selectedIndex == 2
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Icon(
          _selectedIndex == _getIndexForLabel(label) ? activeIcon : icon,
          size: isCenter ? 32 : 24,
        ),
      ),
      activeIcon: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          shape: isCenter ? BoxShape.circle : BoxShape.rectangle,
          color: isCenter
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Icon(
          activeIcon,
          size: isCenter ? 32 : 24,
        ),
      ),
      label: label,
    );
  }

  int _getIndexForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return 0;
      case 'bus list':
        return 1;
      case 'bus status':
        return 2;
      case 'contact':
        return 3;
      case 'profile':
        return 4;
      default:
        return 0;
    }
  }
}
