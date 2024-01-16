import 'package:flutter/material.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/presensi.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/presensi_repository.dart';
import 'package:flutter_absensi_pt_bulog/helper/sharedpreferences.dart';
import 'package:flutter_absensi_pt_bulog/style/style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final PresensiRepository presensiRepository = Get.find<PresensiRepository>();
  final TextEditingController _selectedDate = TextEditingController();
  var _month = DateTime.now().month;
  var _year = DateTime.now().year;
  var _userId = '', _present = 0, _absent = 0, _permit = 0, _holiday = 0;

  final List<Widget> _listAbsensi = [];

  @override
  void initState() {
    super.initState();
    _selectedDate.text = "${DateTime.now().year} - ${DateTime.now().month}";
    DataSharedPreferences().readString("id").then((value) {
      setState(() {
        _userId = value!;
      });
      getAbsensi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _selectedDate,
              readOnly: true,
              decoration: Style().dekorasiInput(
                hint: "Tanggal",
                icon: const Icon(
                  Icons.calendar_month,
                ),
              ),
              onTap: () {
                showMonthPicker(
                  context: context,
                  initialDate: DateTime.now(),
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      _selectedDate.text = "${date.year} - ${date.month}";
                      _month = date.month;
                      _year = date.year;
                    });
                    getAbsensi();
                  }
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Card(
                    color: Colors.green[50],
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Present",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("$_present Day(s)"),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Card(
                    color: Colors.red[50],
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Absent",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("$_absent Day(s)"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Card(
                    color: Colors.orange[50],
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Permit",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("$_permit Day(s)"),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Card(
                    color: Colors.blue[50],
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Holidays",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("$_holiday Day(s)"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Rekap Absensi : ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: _listAbsensi),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getAbsensi() {
    _present = 0;
    _absent = 0;
    _permit = 0;
    _holiday = 0;
    _listAbsensi.clear();

    presensiRepository
        .getPresensiListDateRange(_userId, _month, _year)
        .then((presensiList) {
      for (Presensi presensi in presensiList) {
        Color? warna;
        String keterangan = "";

        // Adjust conditions based on your Presensi model
        if (presensi.type == "H") {
          keterangan = "HADIR";
          warna = Colors.green[50];
          _present++;
        } else if (presensi.type == "A") {
          keterangan = "ABSENT";
          warna = Colors.red[50];
          _absent++;
        } else if (presensi.type == "I") {
          keterangan = "IZIN - ${presensi.remark}";
          warna = Colors.orange[50];
          _permit++;
        } else if (presensi.type == "L") {
          keterangan = "LIBUR";
          warna = Colors.blue[50];
          _holiday++;
        }

        _listAbsensi.add(
          Card(
            color: warna,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    presensi.timestamp?.toDate() != null
                        ? DateFormat('dd MMM yyyy HH:mm')
                            .format(presensi.timestamp!.toDate())
                        : 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      // fontSize: 25,
                    ),
                  ),
                  const VerticalDivider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  Text(keterangan),
                ],
              ),
            ),
          ),
        );
      }

      setState(() {});
    });
  }
}
