import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; 
import 'package:project_crypto/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    
    if (username == null || password == null) {
      await prefs.setString('username', 'student');
      await prefs.setString('password', 'password123');
    }
  }

 
  _login() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2)); 

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    if (mounted) {
      if (_usernameController.text == storedUsername &&
          _passwordController.text == storedPassword) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid username or password'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kBorderColor),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Login',
                          style: kBodyLarge.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        
                        // Username Field
                        TextField(
                          controller: _usernameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: kBodyMedium,
                            hintText: 'default: student',
                            hintStyle: TextStyle(color: Colors.white54),
                            prefixIcon: Icon(Icons.person, color: kButtonColor),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: kBodyMedium,
                            hintText: 'default: password123',
                            hintStyle: TextStyle(color: Colors.white54),
                            prefixIcon: Icon(Icons.lock, color: kButtonColor),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 30),
                        
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : Text(
                                    'Login',
                                    style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40), // Jarak

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kBorderColor),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: kButtonColor,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Bisma Maulana',
                          style: kBodyLarge.copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),
                        Text('NIM: 221351025', style: kBodyMedium),
                        SizedBox(height: 4),
                        Text('Kelas: Pagi C', style: kBodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}