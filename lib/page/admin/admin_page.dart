import 'package:flutter/material.dart';
import 'package:flutter_absensi_pt_bulog/helper/sharedpreferences.dart';
import 'package:flutter_absensi_pt_bulog/page/admin/cek_absensi.dart';
import 'package:flutter_absensi_pt_bulog/page/admin/karyawan_page.dart';
import 'package:flutter_absensi_pt_bulog/splash_screen.dart';
import 'package:get/get.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              DataSharedPreferences().clearData();
              Get.offAll(() => const SplashScreen());
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: (1 / 0.7),
          children: [
            InkWell(
              onTap: () {
                Get.to(() => const CekAbsensiPage());
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Image.asset(
                          "assets/absence.png",
                          scale: 2,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.orange,
                        child: const Center(
                          child: Text(
                            "Absensi",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => const KaryawanPage());
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Image.asset(
                          "assets/employee.png",
                          scale: 2,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.orange,
                        child: const Center(
                          child: Text(
                            "Karyawan",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
