import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/karyawan.dart';

class Presensi {
  Presensi({
    this.idPresensi,
    this.userId,
    this.karyawan,
    this.remark,
    this.latitude,
    this.longitude,
    this.foto,
    this.timestamp,
    this.type,
    this.approval,
  });
  String? idPresensi;
  String? userId;
  Karyawan? karyawan;
  String? remark;
  String? latitude;
  String? longitude;
  String? foto;
  Timestamp? timestamp;
  String? type;
  bool? approval;
}
