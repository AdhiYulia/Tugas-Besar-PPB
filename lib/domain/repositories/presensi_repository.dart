import 'dart:io';

import 'package:flutter_absensi_pt_bulog/domain/entities/presensi.dart';

abstract class PresensiRepository {
  Future<Presensi?> addNewPresensi(Presensi presensi, File foto);
  Future<List<Presensi>> getPresensiList();
  Future<List<Presensi>> getPresensiByDate(DateTime date);
  Future<List<Presensi>> getPresensiListDateRange(
      String userId, int month, int year);
  Future<Presensi?> getPresensiById(String id);
  Future<void> updatePresensi(Presensi presensi);
  Future<void> deletePresensi(String idPresensi);
}
