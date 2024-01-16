import 'package:flutter_absensi_pt_bulog/domain/entities/user.dart';

abstract class AuthRepository {
  Future<UserLogin?> signInWithEmailAndPassword(String email, String password);

  Future<UserLogin?> registerWithEmailAndPassword(
      String email, String password, String name);
  Future<bool> updatePassword(
      String email, String currentPassword, String newPassword);
}
