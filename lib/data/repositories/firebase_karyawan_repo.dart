// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/karyawan.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/karyawan_repository.dart';

class FirebaseKaryawanRepository implements KaryawanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'karyawan'; // Replace with your collection name

  @override
  Future<Karyawan?> addNewKaryawan(Karyawan karyawan) async {
    try {
      await _firestore.collection(collectionName).doc(karyawan.idKaryawan).set({
        'name': karyawan.name,
        'email': karyawan.email,
        'nik': karyawan.nik,
        'phone': karyawan.phone,
        'dob': karyawan.dob,
        'address': karyawan.address,
        'isUpdate': karyawan.isUpdate ?? false,
      });

      return Karyawan(
        idKaryawan: karyawan.idKaryawan,
        name: karyawan.name,
        email: karyawan.email,
        nik: karyawan.nik,
        phone: karyawan.phone,
        dob: karyawan.dob,
        address: karyawan.address,
        isUpdate: karyawan.isUpdate ?? false,
      );
    } catch (e) {
      print('Error adding new Karyawan: $e');
      return null;
    }
  }

  @override
  Future<void> deletKaryawan(String idKaryawan) async {
    try {
      await _firestore.collection(collectionName).doc(idKaryawan).delete();
    } catch (e) {
      print('Error deleting Karyawan: $e');
    }
  }

  @override
  Future<Karyawan?> getKaryawanById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(collectionName).doc(id).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        return Karyawan(
          idKaryawan: documentSnapshot.id,
          name: data['name'],
          email: data['email'],
          nik: data['nik'],
          phone: data['phone'],
          dob: (data['dob'] as Timestamp?)?.toDate(),
          address: data['address'],
          isUpdate: data['isUpdate'],
        );
      }
    } catch (e) {
      print('Error getting Karyawan by ID: $e');
    }
    return null;
  }

  @override
  Future<List<Karyawan>> getKaryawanList() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionName).get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Karyawan(
          idKaryawan: doc.id,
          name: data['name'],
          email: data['email'],
          nik: data['nik'],
          phone: data['phone'],
          dob: (data['dob'] as Timestamp?)?.toDate(),
          address: data['address'],
          isUpdate: data['isUpdate'],
        );
      }).toList();
    } catch (e) {
      print('Error getting Karyawan list: $e');
      return [];
    }
  }

  @override
  Future<void> updateKaryawan(Karyawan karyawan) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(karyawan.idKaryawan)
          .update({
        'name': karyawan.name,
        'email': karyawan.email,
        'nik': karyawan.nik,
        'phone': karyawan.phone,
        'dob': karyawan.dob,
        'address': karyawan.address,
        'isUpdate': karyawan.isUpdate ?? false,
      });
    } catch (e) {
      print('Error updating Karyawan: $e');
    }
  }
}
