import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Assuming these paths are correct relative to your register_page.dart
import '../../shared/views/main_navigation.dart'; // Adjust path as per your project structure
import '../viewmodels/user_cubit.dart';
import '../viewmodels/user_state.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onSwitchToLogin;

  const RegisterPage({super.key, this.onSwitchToLogin});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // New controller for confirm password

  bool _isLoading = false; // Local state to manage loading indicator
  bool _isPasswordVisible = false; // State for password visibility
  bool _isConfirmPasswordVisible = false; // State for confirm password visibility

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Dispose the new controller
    super.dispose();
  }

  /// Handles the registration logic when the "Sign Up" button is pressed.
  /// It validates the form, then dispatches the register event to the UserCubit.
  void _register() {
    // Validate all fields in the form
    if (_formKey.currentState?.validate() ?? false) {
      // If validation passes, set loading state
      setState(() {
        _isLoading = true;
      });

      // Dispatch the register event to the UserCubit
      context.read<UserCubit>().register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  /// Placeholder for Google Sign-Up.
  /// Your UserCubit currently doesn't have a method for Google sign-up.
  /// You would need to add a `loginWithGoogle` or `registerWithGoogle` method
  /// to your `AuthService` and `UserCubit` to implement this.
  void _signInWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign-Up not yet implemented in UserCubit.'),
        backgroundColor: Colors.orange,
      ),
    );
    // Example:
    // context.read<UserCubit>().loginWithGoogle(); // If you add this method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color similar to the provided image
      backgroundColor: const Color(0xFFF8F5F8), // A very light lavender/purple
      // Removed AppBar to match the image
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          // Reset loading state after any state change
          setState(() {
            _isLoading = false;
          });

          if (state is UserAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome, ${state.user.name}! Registration successful.'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to MainNavigation upon successful authentication
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainNavigation()),
            );
          } else if (state is UserError) {
            // Show error message from the UserCubit
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is UserLoading) {
            // Set loading state when cubit is loading
            setState(() {
              _isLoading = true;
            });
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column( // Use a Column to stack the header and the card
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header similar to the image
                  const Text(
                    'BIG EAR',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Springbed · pillow · accessories',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40), // Spacing between header and card
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Removed "Create Your Account" to match the image's login style
                            // The image doesn't show a title inside the card for login/register
                            // const Text(
                            //   'Create Your Account',
                            //   style: TextStyle(
                            //     fontSize: 28,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.blueAccent,
                            //   ),
                            // ),
                            // const SizedBox(height: 30),
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'Enter your full name',
                                // Removed prefixIcon to match the image's input field style
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(color: Colors.grey.shade300), // Lighter border
                                ),
                                enabledBorder: OutlineInputBorder( // Ensure consistent border when enabled
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder( // Focused border color
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // Adjust padding
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                hintText: 'Enter your email',
                                // Removed prefixIcon
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible, // Toggle visibility
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                // Removed prefixIcon
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                                suffixIcon: IconButton( // Eye icon
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey, // Make eye icon grey
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible, // Toggle visibility
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Re-enter your password',
                                // Removed prefixIcon
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                                suffixIcon: IconButton( // Eye icon
                                  icon: Icon(
                                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey, // Make eye icon grey
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            // Show loading indicator or Sign Up button
                            _isLoading
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _register, // Call the register method
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF3B5998), // Darker blue, similar to image
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6.0), // Adjusted border radius to 6.0
                                        ),
                                        elevation: 5, // Subtle shadow
                                      ),
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            // The image doesn't show OR or Google sign-up for login,
                            // but keeping it here as it was part of previous requests for register.
                            const Divider(height: 40, thickness: 1),
                            const Text(
                              'OR',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const Divider(height: 40, thickness: 1),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(FontAwesomeIcons.google, color: Colors.black54),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text('G', style: TextStyle(color: Colors.blue)),
                                    Text('o', style: TextStyle(color: Colors.red)),
                                    Text('o', style: TextStyle(color: Colors.yellow)),
                                    Text('g', style: TextStyle(color: Colors.blue)),
                                    Text('l', style: TextStyle(color: Colors.green)),
                                    Text('e', style: TextStyle(color: Colors.red)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Sign up',
                                      style: TextStyle(fontSize: 16, color: Colors.black87), // Text color for outlined button
                                    ),
                                  ],
                                ),
                                onPressed: _isLoading ? null : _signInWithGoogle,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade400), // Slightly darker border for contrast
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Navigate to Login Page (Demo)')),
                                );
                              },
                              child: const Text(
                                'Already have an account? Log in',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
