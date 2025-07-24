import 'package:big_ear/modules/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/user_cubit.dart';
import '../viewmodels/user_state.dart';
import 'login_view.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        // When state becomes UserInitial (e.g., after logout), go back to LoginView
        if (state is UserInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false, // Removes all previous routes
          );
        }
      },
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          String name = 'Guest';
          String email = '';
          bool isAuthenticated = false;

          if (state is UserAuthenticated) {
            name = state.user.name;
            email = state.user.email;
            isAuthenticated = true;
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false, // Hide back button
            ),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header section
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.black12,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        if (email.isNotEmpty)
                          Text(
                            email,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Conditional actions based on auth state
                  if (isAuthenticated) ...[
                    // --- Show these options if LOGGED IN ---
                    AccountTile(
                      title: "Edit Profile",
                      icon: Icons.edit,
                      onTap: () {
                        // To-do: Navigate to an edit profile screen
                      },
                    ),
                    AccountTile(
                      title: "My Orders",
                      icon: Icons.shopping_bag,
                      onTap: () {},
                    ),
                    AccountTile(
                      title: "Settings",
                      icon: Icons.settings,
                      onTap: () {},
                    ),
                    const Spacer(),
                    AccountTile(
                      title: "Log Out",
                      icon: Icons.exit_to_app,
                      isLogout: true, // Make it red
                      onTap: () {
                        // Call the logout method from the cubit
                        context.read<UserCubit>().logout();
                      },
                    ),
                  ] else ...[
                    // --- Show this if LOGGED IN AS GUEST ---
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate back to the login screen to sign in properly
                         Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginView()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white
                      ),
                      child: const Text("Login / Sign Up"),
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Reusable tile for account options
class AccountTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLogout;

  const AccountTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLogout ? Colors.red : Colors.black;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(color: color)),
        trailing: isLogout ? null : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}