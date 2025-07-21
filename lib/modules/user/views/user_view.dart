import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/user_cubit.dart';
import '../viewmodels/user_state.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        String name = 'Guest';
        if (state is UserAuthenticated) {
          name = state.user.name;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const SizedBox(), // Remove back button
            actions: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.more_vert, color: Colors.black54),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "BIG EAR",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Text(
                        "springbed · accessories · 2in1bed",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      // Avatar & Name
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.black12,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      // Edit button
                      TextButton(
                        onPressed: () {
                          // Handle edit profile
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                const Text(
                  "Your Account",
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 12),

                // Account Items
                AccountTile(title: "Appointments", icon: Icons.calendar_today),
                AccountTile(title: "Gift Cards", icon: Icons.card_giftcard),
                AccountTile(title: "Packages", icon: Icons.widgets),
                AccountTile(title: "Memberships", icon: Icons.person),
                AccountTile(title: "Loyalty", icon: Icons.loyalty),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AccountTile extends StatelessWidget {
  final String title;
  final IconData icon;

  const AccountTile({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Handle item tap
        },
      ),
    );
  }
}
