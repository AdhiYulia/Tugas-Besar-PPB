// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/izin.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/izin_repository.dart';
import 'package:flutter_absensi_pt_bulog/helper/format_changer.dart';
import 'package:flutter_absensi_pt_bulog/helper/sharedpreferences.dart';
import 'package:flutter_absensi_pt_bulog/style/style.dart';
import 'package:get/get.dart';

class IzinPage extends StatefulWidget {
  const IzinPage({super.key});

  @override
  State<IzinPage> createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  final IzinRepository izinRepository = Get.find<IzinRepository>();
  final TextEditingController _from = TextEditingController();
  final TextEditingController _until = TextEditingController();
  final TextEditingController _reason = TextEditingController();

  String _userId = '';

  @override
  void initState() {
    super.initState();
    DataSharedPreferences().readString("id").then((value) {
      setState(() {
        _userId = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajukan Izin"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _from,
              readOnly: true,
              onTap: () {
                showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2099))
                    .then((value) {
                  if (value != null) {
                    _from.text = FormatChanger().tanggalAPI(value.start);
                    _until.text = FormatChanger().tanggalAPI(value.end);
                  }
                });
              },
              decoration: Style().dekorasiInput(
                hint: "From",
                icon: const Icon(
                  Icons.calendar_month,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _until,
              readOnly: true,
              onTap: () {
                showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2099))
                    .then((value) {
                  if (value != null) {
                    _from.text = FormatChanger().tanggalAPI(value.start);
                    _until.text = FormatChanger().tanggalAPI(value.end);
                  }
                });
              },
              decoration: Style().dekorasiInput(
                hint: "Until",
                icon: const Icon(
                  Icons.calendar_month,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _reason,
              decoration: Style().dekorasiInput(
                hint: "Reason",
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_from.text.isEmpty ||
              _until.text.isEmpty ||
              _reason.text.isEmpty) {
            Get.snackbar("Maaf", "Harap Lengkapi Data Anda");
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Ajukan Izin Ini?"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      sendIzin();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "Ajukan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        child: const Icon(
          Icons.save,
        ),
      ),
    );
  }

  void sendIzin() async {
    try {
      if (_from.text.isEmpty || _until.text.isEmpty || _reason.text.isEmpty) {
        Get.snackbar("Maaf", "Harap Lengkapi Data Anda");
      } else {
        Izin izin = Izin(
          userId: _userId,
          from: DateTime.parse(_from.text),
          until: DateTime.parse(_until.text),
          reason: _reason.text,
        );

        await izinRepository.addIzin(izin);

        Get.back();
        Get.snackbar("Success", "Izin berhasil diajukan");
      }
    } catch (e) {
      print("Error sending Izin: $e");
    }
  }
}
