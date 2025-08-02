import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/views/home_view.dart';
import '../../ai_chat/views/ai_chat_view.dart';
import '../../items/views/items_view.dart';
import '../../user/views/login_view.dart';
import '../../user/views/register_view.dart';
import '../../user/views/user_view.dart';
import '../../user/viewmodels/user_cubit.dart';
import '../../user/viewmodels/user_state.dart';
import '../../shared/constants/colors.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  int _authPageIndex = 0; // 0 = login, 1 = register

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 3) _authPageIndex = 0;
    });
  }

  void _switchAuthPage(int index) {
    setState(() {
      _authPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final List<Widget> pages = [
          const HomeView(),
          const ItemsView(),
          const AIChatView(),
          if (state is UserAuthenticated || state is UserGuest)
            const UserView()
          else if (_authPageIndex == 0)
            LoginView(onSwitchToRegister: () => _switchAuthPage(1))
          else
            RegisterPage(onSwitchToLogin: () => _switchAuthPage(0)),
        ];

        return Scaffold(
          body: pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: primaryBlue,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.bed), label: 'Produk'),
              BottomNavigationBarItem(icon: Icon(Icons.psychology_alt), label: 'AI Assistant'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
