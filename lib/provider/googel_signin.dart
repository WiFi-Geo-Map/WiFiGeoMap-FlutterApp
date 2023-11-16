import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final globalUser = await googleSignIn.signIn();
      if (globalUser == null) return;
      _user = globalUser;

      final googleAuth = await globalUser.authentication;

      final crediential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =  await FirebaseAuth.instance.signInWithCredential(crediential);
      User? user = userCredential.user;

      if (user != null) {
        if (user.email != null && user.email!.endsWith('@iith.ac.in')) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            await _firestore.collection("Users").doc(user.uid).set({
              "User Name": user.displayName,
              "User Profile": user.photoURL,
              "User id": user.uid,
              "User email": user.email,
            });
          }
        } else {
          await googleSignIn.signOut();
          await FirebaseAuth.instance.signOut();
          return;
        }
      }
    } catch (e) {
      stdout.write(e.toString());
    }
    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
