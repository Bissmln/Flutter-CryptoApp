import 'package:flutter/material.dart';
import 'package:project_crypto/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); 

    if (!mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPassword = prefs.getString('password');

    if (_oldPasswordController.text == storedPassword) {
      await prefs.setString('password', _newPasswordController.text);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: Colors.green,
        ),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Current password is incorrect'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimaryColor,
              kScaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
         
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Form( 
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.lock_reset,
                      size: 60,
                      color: kButtonColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Change Password',
                      style: kBodyLarge.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Update your account password',
                      style: kBodyMedium,
                    ),
                    
                    const SizedBox(height: 40),
      
                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        labelText: 'Current Password',
                        icon: Icons.lock_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        labelText: 'New Password',
                        icon: Icons.lock,
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        labelText: 'Confirm New Password',
                        icon: Icons.lock_clock,
                      ),
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : Text(
                                'Update Password',
                                style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String labelText, required IconData icon}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: kBodyMedium,
      prefixIcon: Icon(icon, color: kButtonColor),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.yellowAccent),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.yellowAccent, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    );
  }
}