import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:menasyp/screens/contacts_screen.dart';
import 'package:menasyp/screens/inbox_screen.dart';
import 'package:menasyp/screens/settings_screen.dart';
import 'package:menasyp/screens/tourisme_screen.dart';
import 'package:menasyp/services/user_provider.dart';
import 'package:menasyp/widgets/home_widget.dart';
import 'package:provider/provider.dart';

import "package:menasyp/core/theme.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  Widget _buildBottomNavigation(BuildContext context) {
     final user = Provider.of<UserProvider>(context).user;
    final bool isAdmin = user?['role'] == 'admin';
    final List<BottomNavigationBarItem> bottomNavItems = [
      const BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Iconsax.map), label: 'Map'),
      const BottomNavigationBarItem(icon: Icon(Iconsax.book), label: 'Contacts'),
      const BottomNavigationBarItem(icon: Icon(Iconsax.setting), label: 'Settings'),
       if (isAdmin) // Only show inbox tab for admin
        const BottomNavigationBarItem(icon: Icon(Iconsax.message), label: 'Inbox'),
    ];

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      backgroundColor:  backgroundColor,
      selectedItemColor: const Color(0xffFF2057),
      unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      type: BottomNavigationBarType.fixed,
      items: bottomNavItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    
  
    return Scaffold(
      backgroundColor:  backgroundColor,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children:const [
          Center(child: SchedulePage()),
          Center(child: TravelHomePage()),
          Center(child: ContactsScreen()),
          Center(child: ProfileScreen()),
       InboxScreen()
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }
}