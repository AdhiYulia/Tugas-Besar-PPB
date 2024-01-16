import 'package:flutter/material.dart';
import 'package:flutter_absensi_pt_bulog/data/repositories/firebase_auth_repo.dart';
import 'package:flutter_absensi_pt_bulog/data/repositories/firebase_karyawan_repo.dart';
import 'package:flutter_absensi_pt_bulog/helper/format_changer.dart';
import 'package:flutter_absensi_pt_bulog/helper/sharedpreferences.dart';
import 'package:flutter_absensi_pt_bulog/splash_screen.dart';
import 'package:flutter_absensi_pt_bulog/style/style.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmation = TextEditingController();

  var _id = "";
  var _name = "";
  var _email = "";
  var _nik = "";
  var _phone = "";
  var _dob = "";
  var _address = "";

  @override
  void initState() {
    super.initState();
    DataSharedPreferences().readString("id").then((value) {
      setState(() {
        _id = value!;
      });
      FirebaseKaryawanRepository().getKaryawanById(_id).then((karyawan) {
        if (karyawan != null) {
          setState(() {
            _name = karyawan.name ?? '';
            _email = karyawan.email ?? '';
            _nik = karyawan.nik ?? '';
            _phone = karyawan.phone ?? '';
            _dob = karyawan.dob != null
                ? FormatChanger().tanggalAPI(karyawan.dob!)
                : '';
            _address = karyawan.address ?? '';
          });
        } else {
          // Handle the case when Karyawan is not found
          Get.snackbar("Error", "Karyawan not found");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Anda"),
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/app_logo.png",
                  scale: 3,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Card(
                elevation: 10,
                color: Colors.orange,
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(10),
                  child: Table(
                    border: const TableBorder(
                        horizontalInside: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.white)),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const <int, TableColumnWidth>{
                      0: FractionColumnWidth(0.3),
                      1: FractionColumnWidth(0.05),
                      2: FractionColumnWidth(0.65),
                    },
                    children: [
                      TableRow(children: [
                        const Text(
                          "Nama",
                          style: TextStyle(color: Colors.white),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _name,
                          textAlign: TextAlign.end,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                      TableRow(children: [
                        const Text(
                          "Nik",
                          style: TextStyle(color: Colors.white),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _nik,
                          textAlign: TextAlign.end,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                      TableRow(children: [
                        const Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _email,
                          textAlign: TextAlign.end,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                      TableRow(children: [
                        const Text(
                          "Phone",
                          style: TextStyle(color: Colors.white),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _phone,
                          textAlign: TextAlign.end,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                      TableRow(children: [
                        const Text(
                          "DOB",
                          style: TextStyle(color: Colors.white),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _dob,
                          textAlign: TextAlign.end,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                      TableRow(children: [
                        const Text(
                          "Alamat",
                          style: TextStyle(color: Colors.white),
                        ),
                        const Text(
                          ":",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _address,
                          textAlign: TextAlign.end,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Center(child: Text("Ganti Password")),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _oldPassword,
                              obscureText: true,
                              decoration: Style().dekorasiInput(
                                hint: "Password Lama",
                                icon: const Icon(Icons.vpn_key),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _password,
                              obscureText: true,
                              decoration: Style().dekorasiInput(
                                hint: "Password Baru",
                                icon: const Icon(Icons.vpn_key),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _confirmation,
                              obscureText: true,
                              decoration: Style().dekorasiInput(
                                hint: "Konfirmasi",
                                icon: const Icon(Icons.vpn_key),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_password.text.length < 5) {
                                Get.snackbar("Maaf",
                                    "Minimal Karakter untuk Password adalah 5");
                              } else if (_password.text != _confirmation.text) {
                                Get.snackbar(
                                  "Maaf",
                                  "Password dan Konfirmasi Tidak Sama",
                                );
                              } else {
                                FirebaseAuthRepository()
                                    .updatePassword(_email, _oldPassword.text,
                                        _password.text)
                                    .then((success) {
                                  if (success) {
                                    _oldPassword.text = "";
                                    _password.text = "";
                                    _confirmation.text = "";
                                    Get.back();
                                    Get.snackbar(
                                        "Success", "Password berhasil diganti");
                                  } else {
                                    Get.snackbar(
                                        "Error", "Gagal mengganti password");
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    "Ganti Password",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
