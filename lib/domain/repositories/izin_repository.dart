import 'package:flutter_absensi_pt_bulog/domain/entities/izin.dart';

abstract class IzinRepository {
  Future<List<Izin>> getIzinList();
  Future<Izin?> getIzinById(String id);
  Future<void> addIzin(Izin izin);
  Future<void> updateIzin(Izin izin);
  Future<void> deleteIzin(String id);
}
