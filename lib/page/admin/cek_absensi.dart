// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/presensi.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/presensi_repository.dart';
import 'package:flutter_absensi_pt_bulog/helper/format_changer.dart';
import 'package:flutter_absensi_pt_bulog/style/style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CekAbsensiPage extends StatefulWidget {
  const CekAbsensiPage({super.key});

  @override
  State<CekAbsensiPage> createState() => _CekAbsensiPageState();
}

class _CekAbsensiPageState extends State<CekAbsensiPage> {
  final PresensiRepository presensiRepository = Get.find<PresensiRepository>();
  final TextEditingController _tanggal = TextEditingController();

  final List<Widget> _listAbsensi = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _tanggal.text = FormatChanger().tanggalIndo(DateTime.now());
    });
    getData();
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
            TextField(
              controller: _tanggal,
              readOnly: true,
              onTap: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2099),
                ).then((value) {
                  if (value != null) {
                    _tanggal.text = FormatChanger().tanggalIndo(value);
                    getData();
                  }
                });
              },
              decoration: Style().dekorasiInput(
                hint: "Tanggal",
                icon: const Icon(Icons.calendar_month),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: _listAbsensi,
            ),
          ],
        ),
      ),
    );
  }

  void getData() {
    DateTime dateTime = DateFormat('dd-MM-yyyy').parse(_tanggal.text);
    presensiRepository
        .getPresensiByDate(dateTime)
        .then((List<Presensi?> presensiList) {
      _listAbsensi.clear();

      for (Presensi? presensi in presensiList) {
        if (presensi != null) {
          _listAbsensi.add(
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Konfirmasi Absensi ini?"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Image.network(
                            presensi.foto ?? "",
                            scale: 10,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Nama : ${presensi.karyawan!.name}"),
                        Text("Keterangan : ${presensi.remark}"),
                        Text(
                            "Koordinat : ${presensi.latitude}, ${presensi.longitude}"),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          updateApproval(presensi, false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                        ),
                        child: const Text("Tolak"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          updateApproval(presensi, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[50],
                        ),
                        child: const Text("Setujui"),
                      ),
                    ],
                  ),
                );
              },
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      presensi.approval == true
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : presensi.approval == false
                              ? const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.question_mark,
                                  color: Colors.orange,
                                ),
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (presensi.karyawan!.name ?? '').toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          Text(presensi.remark ?? ''),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
      setState(() {});
    });
  }

  void updateApproval(Presensi presensi, bool approval) {
    presensi.approval = approval;
    presensiRepository.updatePresensi(presensi).then((_) {
      // Assuming you have a method to refresh the data (e.g., getData)
      getData();
    }).catchError((error) {
      print('Error updating Presensi: $error');
    });
  }
}
