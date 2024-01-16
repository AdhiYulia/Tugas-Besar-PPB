// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/presensi.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/presensi_repository.dart';
import 'package:flutter_absensi_pt_bulog/helper/format_changer.dart';
import 'package:flutter_absensi_pt_bulog/helper/sharedpreferences.dart';
import 'package:flutter_absensi_pt_bulog/page/user/user_page.dart';
import 'package:flutter_absensi_pt_bulog/style/style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({super.key});

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  final PresensiRepository presensiRepository = Get.find<PresensiRepository>();
  final TextEditingController _koordinat = TextEditingController();
  final TextEditingController _tanggal = TextEditingController();
  File? foto;

  bool servicestatus = false;
  bool haspermission = false;
  LocationPermission? permission;
  Position? currentPosition;
  double currentLongitude = 0;
  double currentLatitude = 0;
  String? currentDate = "";
  StreamSubscription<Position>? positionStream;

  String _id = '';

  @override
  void initState() {
    super.initState();
    DataSharedPreferences().readString("id").then((value) {
      setState(() {
        _id = value!;
      });
    });
    checkGps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Absensi"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async => await ambilFoto(),
              child: Center(
                child: Column(
                  children: [
                    (foto == null
                        ? Container(
                            width: 300,
                            height: 450,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 40,
                            ),
                          )
                        : Container(
                            width: 300,
                            height: 450,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(foto!),
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                    const Text("Foto Wajah Anda")
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _koordinat,
              decoration: Style().dekorasiInput(
                hint: "Koordinat",
                icon: const Icon(Icons.pin_drop),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _tanggal,
              decoration: Style().dekorasiInput(
                hint: "Tanggal",
                icon: const Icon(Icons.timelapse),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (foto == null) {
            Get.snackbar("Maaf", "Anda Belum Melakukan Pengambilan Foto");
          } else if (_koordinat.text.isEmpty) {
            Get.snackbar("Maaf", "Lokasi Anda Belum Terdeteksi");
          } else {
            sendAbsensi();
          }
        },
        child: const Icon(
          Icons.save,
        ),
      ),
    );
  }

  void sendAbsensi() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Center(child: Text('Mohon Tunggu')),
        content: SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    try {
      DateTime dateTime =
          DateFormat('dd-MM-yyyy HH:mm:ss').parse(_tanggal.text);
      Timestamp timestamp =
          Timestamp.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch);

      Presensi presensi = Presensi(
        userId: _id.toString(),
        latitude: currentLatitude.toString(),
        longitude: currentLongitude.toString(),
        timestamp: timestamp,
        type: "H",
        remark: "Hadir",
      );

      Presensi? addedPresensi =
          await presensiRepository.addNewPresensi(presensi, foto!);

      Get.snackbar('Success', 'Absensi added successfully.');
      Get.back();
      if (addedPresensi != null && addedPresensi.idPresensi != null) {
        Get.offAll(() => const UserPage());
      } else {
        Get.snackbar('Error', 'Failed to add Absensi.');
      }
    } catch (e) {
      print('Error adding new Absensi: $e');
      Get.back();
      Get.snackbar('Error', 'Failed to add Absensi.');
    }
  }

  Future<void> ambilFoto() async {
    await ImagePicker()
        .pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    )
        .then((value) {
      if (value!.path.isNotEmpty) {
        foto = File(value.path);
        setState(() {});
      }
    }).catchError((err) {});
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Maaf", "Lokasi akses tidak aktif!");
        } else if (permission == LocationPermission.deniedForever) {
          Get.snackbar("Maaf", "Lokasi akses tidak aktif!");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      if (haspermission) {
        setState(() {});
        getCurrentPosition();
      }
    } else {
      Get.snackbar("Maaf", "GPS tidak aktif!");
    }

    setState(() {});
  }

  getCurrentPosition() async {
    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
    setState(() {
      currentLongitude = currentPosition!.longitude;
      currentLatitude = currentPosition!.latitude;
      currentDate = FormatChanger().tanggalJam(
        currentPosition!.timestamp.add(const Duration(hours: 7)),
      );
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.low,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position currentPosition) {
      setState(() {
        currentLongitude = currentPosition.longitude;
        currentLatitude = currentPosition.latitude;
        currentDate = FormatChanger().tanggalJam(
          currentPosition.timestamp.add(const Duration(hours: 7)),
        );
        _tanggal.text = currentDate.toString();
        _koordinat.text = "$currentLongitude, $currentLatitude";
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    positionStream!.cancel();
  }
}
