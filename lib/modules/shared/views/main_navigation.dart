import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/views/home_view.dart';
import '../../ai_chat/views/ai_chat_view.dart';
import '../../review/views/review_view.dart';
import '../../items/views/items_view.dart';
import '../../user/views/user_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    AIChatView(),
    ReviewView(),
    ItemsView(),
    UserView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'AI Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Review'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Produk',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
        ],
      ),
    );
  }
}
