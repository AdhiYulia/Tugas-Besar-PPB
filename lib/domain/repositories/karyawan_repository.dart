import 'package:flutter_absensi_pt_bulog/domain/entities/karyawan.dart';

abstract class KaryawanRepository {
  Future<Karyawan?> addNewKaryawan(Karyawan karyawan);
  Future<List<Karyawan>> getKaryawanList();
  Future<Karyawan?> getKaryawanById(String id);
  Future<void> updateKaryawan(Karyawan karyawan);
  Future<void> deletKaryawan(String idKaryawan);
}
