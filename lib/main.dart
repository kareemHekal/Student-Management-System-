
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hanan_khaled_main/pages/AllStudentPage.dart';
import 'package:hanan_khaled_main/provider.dart';
import 'package:provider/provider.dart';
import 'auth/forgetPasswordPage.dart';
import 'auth/login.dart';
import 'auth/noInternetConnection.dart';
import 'auth/sign up page.dart';
import 'bloc/observer.dart';
import 'colors_app.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'firebase/firebase_options.dart';
import 'home.dart'; // Import connectivity_plus

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check for internet connectivity
  var connectivityResult = await (Connectivity().checkConnectivity());
  bool hasConnection = (connectivityResult != ConnectivityResult.none);

  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MyApp(hasConnection: hasConnection), // Pass the connection status
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasConnection;

  const MyApp({super.key, required this.hasConnection});

  @override
  Widget build(BuildContext context) {
    var dataprovider = Provider.of<DataProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 20, color: app_colors.green,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        useMaterial3: true,
      ),
      home: hasConnection
          ? (dataprovider.firebaseUser != null ? const Homescreen() :const LoginPage())
          : NoConnectionPage(), // Show NoConnectionPage if no internet
      routes: {
        '/SignupPage': (context) =>const SignupPage(),
        '/Forgetpasswordpage': (context) =>ForgetPasswordPage(),
        '/LoginPage': (context) =>  const LoginPage(),
        '/HomeScreen': (context) => const Homescreen(),
        '/StudentsTab': (context) => const AllStudentsTab(),
      },
    );
  }
}
