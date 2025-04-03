import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../colors_app.dart'; // Import your app_colors

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  bool _passwordResetSent = false;

  @override
  void dispose() {
    _emailController.dispose(); // Release the controller
    super.dispose();
  }

  Future passwordReset(context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Successfully"),
          content: Text(
            "Reset password link sent successfully! Check your email.",
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
      setState(() {
        _passwordResetSent = true; // Set the flag to true
      });
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text(
            e.message.toString(),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: app_colors.orange), // Use your orange color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/125.png",
                    width: 300,
                    height: 400,
                  ),
                ],
              ),
              Text(
                textAlign: TextAlign.center,
                "Just enter your email and we will send you a reset password link.",
                style: TextStyle(color: app_colors.green), // Use your blue color
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: TextFormField(
                  obscureText: _passwordResetSent, // Show the password field if the reset link has been sent
                  cursorColor: app_colors.orange, // Use your blue color
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: app_colors.orange.withOpacity(0.1), // Use your orange color
                    filled: true,
                    prefixIcon: const Icon(Icons.email, color: app_colors.orange), // Use your orange color
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Email';
                    } else if (!value.contains('@') || !value.contains('.')) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  passwordReset(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: app_colors.green, // Use your green color
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 30),
                  child: const Text(
                    "Send",
                    style: TextStyle(fontSize: 18, color: app_colors.orange),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
