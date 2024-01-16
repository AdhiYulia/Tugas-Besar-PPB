// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/karyawan.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/presensi.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/presensi_repository.dart';

class FirebasePresensiRepository implements PresensiRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String collectionName = 'presensi';
  final String storagePath = 'presensi_foto';

  @override
  Future<Presensi?> addNewPresensi(Presensi presensi, File foto) async {
    try {
      // Upload foto ke Firebase Cloud Storage
      String photoPath =
          '$storagePath/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask task = _storage.ref().child(photoPath).putFile(foto);
      TaskSnapshot snapshot = await task.whenComplete(() => null);
      presensi.foto = await snapshot.ref.getDownloadURL();

      // Tambahkan data ke Firestore
      DocumentReference docRef =
          await _firestore.collection(collectionName).add({
        'userId': presensi.userId,
        'remark': presensi.remark,
        'latitude': presensi.latitude,
        'longitude': presensi.longitude,
        'foto': presensi.foto,
        'timestamp': presensi.timestamp,
        'type': presensi.type,
        'approval': presensi.approval,
      });

      presensi.idPresensi = docRef.id;

      return presensi;
    } catch (e) {
      print('Error adding new Presensi: $e');
      return null;
    }
  }

  @override
  Future<void> deletePresensi(String idPresensi) async {
    try {
      await _firestore.collection(collectionName).doc(idPresensi).delete();
    } catch (e) {
      print('Error deleting Presensi: $e');
    }
  }

  @override
  Future<Presensi?> getPresensiById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(collectionName).doc(id).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        return Presensi(
          idPresensi: documentSnapshot.id,
          userId: data['userId'],
          remark: data['remark'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          foto: data['foto'],
          timestamp: data['timestamp'],
          type: data['type'],
          approval: data['approval'],
        );
      }
    } catch (e) {
      print('Error getting Presensi by ID: $e');
    }
    return null;
  }

  @override
  Future<List<Presensi>> getPresensiList() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionName).get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Presensi(
          idPresensi: doc.id,
          userId: data['userId'],
          remark: data['remark'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          foto: data['foto'],
          timestamp: data['timestamp'],
          type: data['type'],
          approval: data['approval'],
        );
      }).toList();
    } catch (e) {
      print('Error getting Presensi list: $e');
      return [];
    }
  }

  @override
  Future<void> updatePresensi(Presensi presensi) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(presensi.idPresensi)
          .update({
        'userId': presensi.userId,
        'remark': presensi.remark,
        'latitude': presensi.latitude,
        'longitude': presensi.longitude,
        'foto': presensi.foto,
        'timestamp': presensi.timestamp,
        'type': presensi.type,
        'approval': presensi.approval,
      });
    } catch (e) {
      print('Error updating Presensi: $e');
    }
  }

  @override
  Future<List<Presensi>> getPresensiByDate(DateTime date) async {
    try {
      Timestamp startTimestamp = Timestamp.fromDate(date);
      Timestamp endTimestamp =
          Timestamp.fromDate(date.add(const Duration(days: 1)));

      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
          .where('timestamp', isLessThan: endTimestamp)
          .get();

      List<Presensi> presensiList = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        Karyawan karyawan = await getKaryawanById(data['userId']);

        presensiList.add(Presensi(
          idPresensi: doc.id,
          userId: data['userId'],
          karyawan: karyawan,
          remark: data['remark'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          foto: data['foto'],
          timestamp: data['timestamp'],
          type: data['type'],
          approval: data['approval'],
        ));
      }

      return presensiList;
    } catch (e) {
      print('Error getting Presensi by date: $e');
      return [];
    }
  }

  Future<Karyawan> getKaryawanById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('karyawan').doc(id).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        return Karyawan(
          idKaryawan: documentSnapshot.id,
          name: data['name'],
        );
      }
    } catch (e) {
      print('Error getting Karyawan by ID: $e');
    }
    return Karyawan(idKaryawan: '', name: '');
  }

  @override
  Future<List<Presensi>> getPresensiListDateRange(
      String userId, int month, int year) async {
    try {
      DateTime startOfMonth = DateTime(year, month, 1);
      DateTime endOfMonth =
          DateTime(year, month + 1, 1).subtract(const Duration(days: 1));

      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
          .where('timestamp', isLessThanOrEqualTo: endOfMonth)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Presensi(
          idPresensi: doc.id,
          userId: data['userId'],
          remark: data['remark'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          foto: data['foto'],
          timestamp: data['timestamp'],
          type: data['type'],
          approval: data['approval'],
        );
      }).toList();
    } catch (e) {
      print('Error getting Presensi list: $e');
      return [];
    }
  }
}
