import 'package:flutter/material.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/karyawan.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/karyawan_repository.dart';
import 'package:flutter_absensi_pt_bulog/page/admin/add_karyawan_page.dart';
import 'package:flutter_absensi_pt_bulog/page/admin/admin_page.dart';
import 'package:get/get.dart';

class KaryawanPage extends StatefulWidget {
  const KaryawanPage({super.key});

  @override
  State<KaryawanPage> createState() => _KaryawanPageState();
}

class _KaryawanPageState extends State<KaryawanPage> {
  final KaryawanRepository karyawanRepository = Get.find<KaryawanRepository>();

  final List<Widget> _karyawan = [];

  @override
  void initState() {
    super.initState();
    getKaryawanList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Karyawan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => const AdminPage());
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(child: Column(children: _karyawan)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddKaryawanPage());
        },
        child: const Icon(
          Icons.person_add,
        ),
      ),
    );
  }

  void getKaryawanList() {
    karyawanRepository.getKaryawanList().then((List<Karyawan> karyawanList) {
      for (Karyawan karyawan in karyawanList) {
        _karyawan.add(
          InkWell(
            onTap: () {
              debugPrint('karyawan.name : ${karyawan.idKaryawan}');
              Get.to(
                () => const AddKaryawanPage(),
                arguments: karyawan,
              );
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 10,
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama : ${karyawan.name}"),
                    const Divider(),
                    Text("Email : ${karyawan.email}"),
                    const Divider(),
                    Text("Nik : ${karyawan.nik}"),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      setState(() {});
    }).catchError((error) {
      Get.snackbar("Error", "Failed to fetch karyawan list");
    });
  }
}
