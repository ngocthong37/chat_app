import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email.toString().trim(),
              password: password.toString().trim()))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future registerUserWithEmailAndPassword(
      String fullname, String email, String password) async {
    try {
      // dky user
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email.toString().trim(),
              password: password.toString().trim()))
          .user!;
      if (user != null) {
        await DatabaseService(uid: user.uid).savingUserData(
            fullname.toString().trim(), email.toString().trim());
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFuctions.saveUserLoggedInStatus(false);
      await HelperFuctions.saveEmailNameSF("");
      await HelperFuctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
