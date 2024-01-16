import 'package:flutter/material.dart';
import 'package:flutter_absensi_pt_bulog/data/repositories/firebase_auth_repo.dart';
import 'package:flutter_absensi_pt_bulog/data/repositories/firebase_izin_repo.dart';
import 'package:flutter_absensi_pt_bulog/data/repositories/firebase_karyawan_repo.dart';
import 'package:flutter_absensi_pt_bulog/data/repositories/firebase_presensi_repo.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/auth_repository.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/izin_repository.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/karyawan_repository.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/presensi_repository.dart';
import 'package:flutter_absensi_pt_bulog/splash_screen.dart';
import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDbPLzQn_0M2CkwYXpqGoTA-Ly7UuXD1j0",
          appId: "1:670623880828:web:f128e70e1d974147ab5bf9",
          storageBucket: "database-app-50583.appspot.com",
          messagingSenderId: "670623880828",
          projectId: "database-app-50583"));

  final AuthRepository authRepository = FirebaseAuthRepository();
  final KaryawanRepository karyawanRepository = FirebaseKaryawanRepository();
  final PresensiRepository presensiRepository = FirebasePresensiRepository();
  final IzinRepository izinRepository = FirebaseIzinRepository();
  Get.put<AuthRepository>(authRepository);
  Get.put<KaryawanRepository>(karyawanRepository);
  Get.put<PresensiRepository>(presensiRepository);
  Get.put<IzinRepository>(izinRepository);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Absensi PT Bulog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Colors.orange,
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        fontFamily: "Poppins",
      ),
      home: const SplashScreen(),
      // home: UserPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
