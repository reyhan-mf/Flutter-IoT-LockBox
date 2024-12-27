// navigation.dart
import 'package:flutter/material.dart';
import 'package:lockboxx/model/user_model.dart';

import 'home.dart';
import 'profile.dart';
import 'rent.dart';

class MainPage extends StatefulWidget {
  final User user;
  final int index;
  const MainPage({super.key, required this.user, this.index = 0});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late int _currentIndex = widget.index; // Default ke Home Page

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(user: widget.user), // Pass user to HomePage
      RentPage(user: widget.user), // Rented Page
      ProfilePage(user: widget.user), // Profile Page
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1B383A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white10,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _currentIndex == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.home,
                  color: _currentIndex == 0
                      ? const Color(0xFF1B383A)
                      : Colors.white,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _currentIndex == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.shopping_bag,
                  color: _currentIndex == 1
                      ? const Color(0xFF1B383A)
                      : Colors.white,
                ),
              ),
              label: 'Rented',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.person,
                  color: _currentIndex == 2
                      ? const Color(0xFF1B383A)
                      : Colors.white,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
