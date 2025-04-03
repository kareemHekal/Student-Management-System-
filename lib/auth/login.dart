import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase/firebase_functions.dart';
import '../provider.dart';
import '../colors_app.dart'; // Import your app_colors

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    var dataprovider = Provider.of<DataProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              const SizedBox(height: 50,),
              _inputField(context, dataprovider),
              const SizedBox(height: 30,),

              _forgotPassword(context),
              // Removed the signup section from here
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(context), // Add the bottom navigation bar here
    );
  }

  _header(context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/2....2.png",
          height: 100,
          width: 90,
        ),
        const SizedBox(height: 20,),
        const Text(
          "Welcome Back",
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: app_colors.orange),
        ),
        const Text("Enter your credentials to login",
            style: TextStyle(color: app_colors.green)),
      ],
    );
  }

  _inputField(context, DataProvider dataprovider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          cursorColor: app_colors.orange, // Use your orange color
          style: const TextStyle(color: Colors.black, fontSize: 20),
          controller: _emailController,
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: app_colors.orange.withOpacity(0.1), // Use your orange color
              filled: true,
              prefixIcon: const Icon(Icons.email, color: app_colors.orange)), // Use your orange color
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your Email';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          cursorColor: app_colors.orange, // Use your orange color
          style: const TextStyle(color: Colors.black, fontSize: 20),
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: app_colors.orange.withOpacity(0.1), // Use your orange color
            filled: true,
            prefixIcon: const Icon(Icons.password, color: app_colors.orange), // Use your orange color
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: app_colors.orange, // Use your orange color
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
            return null;
          },
        ),
        const SizedBox(height: 30,),

        ElevatedButton(
          onPressed: () {
            FirebaseFunctions.login(
              onEror: (message) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Error"),
                    content: Text(
                      message,
                      style: const TextStyle(color: Colors.black),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              onSucsses: () {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null && !user.emailVerified) {
                  // If the user's email is not verified, show a dialog to notify them
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Email Verification"),
                      content: const Text(
                        "Your email is not verified. Please verify your email before proceeding.",
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            // Send a verification email
                            await user.sendEmailVerification();
                            Navigator.pop(context);
                          },
                          child: const Text("Send Verification Email"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  );
                }
                dataprovider.initUser;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/HomeScreen',
                      (Route<dynamic> route) => false,
                );
              },
              _emailController.text.trim(),
              _passwordController.text,
              Username: '',
            );
            if (_formKey.currentState!.validate()) {
              print('Email: ${_emailController.text}');
              print('Password: ${_passwordController.text}');
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: app_colors.green, // Use your green color
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: app_colors.orange),
          ),
        ),
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/Forgetpasswordpage');
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: app_colors.orange), // Use your orange color
      ),
    );
  }

  _bottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: app_colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account? ",
              style: TextStyle(color: Colors.blueGrey)),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/SignupPage');
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(color: app_colors.orange), // Use your orange color
            ),
          ),
        ],
      ),
    );
  }
}
