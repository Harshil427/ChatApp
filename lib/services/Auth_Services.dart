// ignore_for_file: unnecessary_null_comparison, file_names, non_constant_identifier_names, avoid_print

import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Login
  Future Login(String email, String password) async {
    //
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      //
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      //
      print(e);
      return e.message;
    }
  }

  //Register
  Future register(String fullname, String email, String password) async {
    //
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      //
      if (user != null) {
        await DatabaseServices(uid: user.uid).updateUserData(fullname, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      //
      print(e);
      return e.message;
    }
  }

  //SignOut
  Future signOut() async {
    try {
      await HelperFunctions.saveUserEmailSF('');
      await HelperFunctions.saveUserNameSF('');
      await HelperFunctions.saveUserLoggedInStatus(false);
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
      return null;
    }
  }
}
