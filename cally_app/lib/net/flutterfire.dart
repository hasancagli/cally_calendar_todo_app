// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// SIGN IN AND REGISTER OPERATIONS

Future<List> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return ['success', 'Signed in successfully!'];
  } on FirebaseAuthException catch (e) {
    String error;
    if (e.code == 'weak-password') {
      error = "The password provided is too weak.";
    } else {
      error = e.message.toString();
    }
    return ['failure', error];
  } catch (e) {
    return ['failure', e.toString()];
  }
}

Future<List> register(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    return ['success', 'Registered successfully!'];
  } on FirebaseAuthException catch (e) {
    String error;
    if (e.code == 'weak-password') {
      error = "The password provided is too weak.";
    } else if (e.code == 'email-already-in-use') {
      error = "The account already exists for that email.";
    } else {
      error = e.message.toString();
    }
    return ['failure', error];
  } catch (e) {
    return ['failure', e.toString()];
  }
}
