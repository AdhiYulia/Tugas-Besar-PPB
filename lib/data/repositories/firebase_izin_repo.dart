// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/izin.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/izin_repository.dart';

class FirebaseIzinRepository implements IzinRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Izin>> getIzinList() async {
    final izinCollection = _firestore.collection('izin');

    try {
      QuerySnapshot querySnapshot = await izinCollection.get();

      List<Izin> izinList = querySnapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        return Izin(
          userId: data['userId'],
          from: data['from'] != null
              ? (data['from'] as Timestamp).toDate()
              : null,
          until: data['until'] != null
              ? (data['until'] as Timestamp).toDate()
              : null,
          reason: data['reason'],
        );
      }).toList();

      return izinList;
    } catch (e) {
      print("Error fetching Izin list: $e");
      return [];
    }
  }

  @override
  Future<Izin?> getIzinById(String idIzin) async {
    final izinCollection = _firestore.collection('izin');

    try {
      DocumentSnapshot documentSnapshot =
          await izinCollection.doc(idIzin).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        return Izin(
          userId: data['userId'],
          from: data['from'] != null
              ? (data['from'] as Timestamp).toDate()
              : null,
          until: data['until'] != null
              ? (data['until'] as Timestamp).toDate()
              : null,
          reason: data['reason'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching Izin by ID: $e");
      return null;
    }
  }

  @override
  Future<void> addIzin(Izin izin) async {
    final izinCollection = _firestore.collection('izin');

    try {
      await izinCollection.add({
        'userId': izin.userId,
        'from': izin.from,
        'until': izin.until,
        'reason': izin.reason,
      });
    } catch (e) {
      print("Error adding Izin: $e");
    }
  }

  @override
  Future<void> updateIzin(Izin izin) async {
    final izinCollection = _firestore.collection('izin');

    try {
      await izinCollection.doc(izin.userId).update({
        'userId': izin.userId,
        'from': izin.from,
        'until': izin.until,
        'reason': izin.reason,
      });
    } catch (e) {
      print("Error updating Izin: $e");
    }
  }

  @override
  Future<void> deleteIzin(String idIzin) async {
    final izinCollection = _firestore.collection('izin');

    try {
      await izinCollection.doc(idIzin).delete();
    } catch (e) {
      print("Error deleting Izin: $e");
    }
  }
}
