// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/auth_repository.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/user.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<UserLogin?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();

        // Retrieve isAdmin field from Firestore
        bool isAdmin = userDoc['isAdmin'] ?? false;
        String name = userDoc['name'] ?? '';
        UserLogin user = UserLogin(
          idUser: firebaseUser.uid,
          email: firebaseUser.email,
          name: name,
          isAdmin: isAdmin,
        );

        return user;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Exception: $e");
      return null;
    }
  }

  @override
  Future<UserLogin?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'name': name,
          'email': email,
          'isAdmin': false,
        });

        return UserLogin(
          idUser: firebaseUser.uid,
          email: firebaseUser.email,
          name: name,
          isAdmin: false,
        );
      }

      return null;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Exception during registration: $e");
      return null;
    }
  }

  @override
  Future<bool> updatePassword(
      String email, String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: email, password: currentPassword);
        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);

        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Exception during password update: $e");
      return false;
    }
  }
}
