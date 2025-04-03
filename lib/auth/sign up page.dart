import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firebase/firebase_functions.dart';
import '../colors_app.dart'; // Import your app_colors

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    Image.asset(
                      "assets/images/2....2.png",
                      height: 100,
                      width: 90,
                    ),const SizedBox(height: 20.0),
                    const Text(
                      "__ Sign up __",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: app_colors
                              .orange // Change to black for better contrast
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Create your account",
                      style: TextStyle(fontSize: 15, color: app_colors.green),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: app_colors.orange.withOpacity(0.1),
                              // Use your orange color
                              filled: true,
                              prefixIcon: const Icon(Icons.person,
                                  color: app_colors
                                      .orange), // Use your orange color
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: app_colors.orange.withOpacity(0.1),
                              // Use your orange color
                              filled: true,
                              prefixIcon: const Icon(Icons.email,
                                  color: app_colors
                                      .orange), // Use your orange color
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: app_colors.orange.withOpacity(0.1),
                              // Use your orange color
                              filled: true,
                              prefixIcon: const Icon(Icons.password,
                                  color: app_colors.orange),
                              // Use your orange color
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: app_colors
                                      .orange, // Use your orange color
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: app_colors.orange.withOpacity(0.1),
                              // Use your orange color
                              filled: true,
                              prefixIcon: const Icon(Icons.password,
                                  color: app_colors.orange),
                              // Use your orange color
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: app_colors
                                      .orange, // Use your orange color
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_isConfirmPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your confirm password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FirebaseFunctions.createAccount(
                          Username: _usernameController.text,
                          onEror: (message) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Error"),
                                content: Text(
                                  message,
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          },
                          onSucsses: () {
                            // Show dialog instead of Snackbar
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Check Your Email"),
                                content: Text(
                                  'Go check your email and verify your account.',
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigate to login page when the button is pressed
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/LoginPage',
                                            (Route<dynamic> route) => false,
                                      );
                                    },
                                    child: Text("Go to Login Page"),
                                  ),
                                ],
                              ),
                            );

                            // Call createTestUser if needed

                            // Wait for 1 second before performing any action (if needed)
                            Future.delayed(Duration(seconds: 1), () {
                              // You can keep any navigation logic here if needed
                            });
                          },
                          _emailController.text,
                          _passwordController.text,
                        );

                        // Debug print statements for your form
                        print('Username: ${_usernameController.text}');
                        print('Email: ${_emailController.text}');
                        print('Password: ${_passwordController.text}');
                      }
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 20, color: app_colors.orange),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: app_colors.green, // Use your green color
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/LoginPage');
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: app_colors.orange), // Use your orange color
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
