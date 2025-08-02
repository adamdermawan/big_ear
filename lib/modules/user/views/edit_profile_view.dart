import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/constants/colors.dart';
import '../viewmodels/user_cubit.dart';
import '../viewmodels/user_state.dart';
import '../models/user.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  String? _originalName;

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserCubit>().state;
    if (userState is UserAuthenticated) {
      nameController.text = userState.user.name;
      emailController.text = userState.user.email;
      _originalName = userState.user.name;
    }
  }

  bool _hasChanges() {
    return nameController.text.trim() != _originalName;
  }

  void _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No changes to save")),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      context.read<UserCubit>().updateProfile(
        name: nameController.text.trim(),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserAuthenticated) {
          // Update was successful
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          // Update the original value
          _originalName = state.user.name;
          Navigator.pop(context); // Go back to user view
        } else if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ubah Profil"),
          actions: [
            if (_hasChanges())
              TextButton(
                onPressed: _isLoading ? null : _onSave,
                child: Text(
                  "Simpan",
                  style: TextStyle(
                    color: _isLoading ? Colors.grey : primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}), // Trigger rebuild to show/hide save button
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  enabled: false, // Make email read-only
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    helperText: "Jika ingin mengubah email lebih baik buat akun baru",
                    helperStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (_hasChanges() && !_isLoading) ? _onSave : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Simpan"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}