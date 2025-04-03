import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'firebase/firebase_functions.dart';
import 'models/usermodel.dart';

class DataProvider extends ChangeNotifier {
  Usermodel? usermodel;
  User? firebaseUser;

  DataProvider(){
    firebaseUser =FirebaseAuth.instance.currentUser;
    if (firebaseUser != null){
      initUser();
    }
  }
  initUser() async{
    usermodel= await FirebaseFunctions.ReadUserData();
    notifyListeners();
  }
}