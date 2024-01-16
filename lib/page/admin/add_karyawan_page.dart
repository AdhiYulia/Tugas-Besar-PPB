import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/karyawan.dart';
import 'package:flutter_absensi_pt_bulog/domain/entities/user.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/auth_repository.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/karyawan_repository.dart';
import 'package:flutter_absensi_pt_bulog/page/admin/karyawan_page.dart';
import 'package:flutter_absensi_pt_bulog/style/style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddKaryawanPage extends StatefulWidget {
  const AddKaryawanPage({super.key});

  @override
  State<AddKaryawanPage> createState() => _AddKaryawanPageState();
}

class _AddKaryawanPageState extends State<AddKaryawanPage> {
  final AuthRepository authRepository = Get.find<AuthRepository>();
  final KaryawanRepository karyawanRepository = Get.find<KaryawanRepository>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nik = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmation = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _address = TextEditingController();

  bool _isUpdate = false;
  late String idKaryawan = '';
  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      Karyawan karyawan = Get.arguments as Karyawan;
      idKaryawan = karyawan.idKaryawan ?? '';
      _name.text = karyawan.name ?? '';
      _email.text = karyawan.email ?? '';
      _nik.text = karyawan.nik ?? '';
      _phone.text = karyawan.phone ?? '';
      _dob.text = karyawan.dob != null
          ? DateFormat('yyyy-MM-dd').format(karyawan.dob!)
          : '';
      _address.text = karyawan.address ?? '';
      _isUpdate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isUpdate ? "Data Karyawan" : "Input Karyawan"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: Style().dekorasiInput(
                hint: "Nama",
                icon: const Icon(
                  Icons.person,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _email,
              decoration: Style().dekorasiInput(
                hint: "Email",
                icon: const Icon(
                  Icons.email,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _nik,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: Style().dekorasiInput(
                hint: "Nik",
                icon: const Icon(
                  Icons.numbers,
                ),
              ),
            ),
            Visibility(
              visible: !_isUpdate,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: Style().dekorasiInput(
                      hint: "Password",
                      icon: const Icon(
                        Icons.vpn_key,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _confirmation,
                    obscureText: true,
                    decoration: Style().dekorasiInput(
                      hint: "Confirmation",
                      icon: const Icon(
                        Icons.vpn_key,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: Style().dekorasiInput(
                hint: "Phone",
                icon: const Icon(
                  Icons.phone_android,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _dob,
              readOnly: true,
              onTap: () {
                showDatePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now().subtract(
                      const Duration(days: 365 * 18),
                    )).then((value) {
                  if (value != null) {
                    setState(() {
                      _dob.text = DateFormat('yyyy-MM-dd').format(value);
                    });
                  }
                });
              },
              decoration: Style().dekorasiInput(
                hint: "Date of Birth",
                icon: const Icon(
                  Icons.calendar_month,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _address,
              decoration: Style().dekorasiInput(
                hint: "Address",
                icon: const Icon(
                  Icons.pin_drop,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_name.text.isEmpty ||
              _nik.text.isEmpty ||
              _dob.text.isEmpty ||
              _address.text.isEmpty) {
            Get.snackbar("Informasi", "Harap Lengkapi Data Anda");
          } else if (!_email.text.isEmail) {
            Get.snackbar("Maaf", "Format Email yang digunakan salah");
          } else if (!_phone.text.isPhoneNumber) {
            Get.snackbar("Maaf", "Format Telefon yang digunakan salah");
          } else if (_password.text.length < 5 && !_isUpdate) {
            Get.snackbar("Maaf", "Minimal Password adalah 5 karakter");
          } else if (_password.text != _confirmation.text && !_isUpdate) {
            Get.snackbar("Maaf", "Password dan Konfirmasi Tidak Sama");
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text("Simpan Karyawan Ini?"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Batal"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      saveKaryawan();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "Simpan",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<UserLogin?> registerUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserLogin? userLogin = await authRepository.registerWithEmailAndPassword(
          email, password, name);
      return userLogin;
    } catch (e) {
      debugPrint("Error registering user: $e");
      return null;
    }
  }

  Future<void> saveKaryawan() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Center(child: Text('Loading')),
        content: SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    if (_isUpdate) {
      Karyawan updatedKaryawan = Karyawan(
        idKaryawan: idKaryawan,
        name: _name.text,
        email: _email.text,
        nik: _nik.text,
        phone: _phone.text,
        dob: DateTime.parse(_dob.text),
        address: _address.text,
        isUpdate: _isUpdate,
      );

      await karyawanRepository.updateKaryawan(updatedKaryawan);
    } else {
      UserLogin? userLogin = await registerUserWithEmailAndPassword(
        _email.text,
        _password.text,
        _name.text,
      );

      if (userLogin != null) {
        Karyawan newKaryawan = Karyawan(
          idKaryawan: userLogin.idUser,
          name: _name.text,
          email: _email.text,
          nik: _nik.text,
          phone: _phone.text,
          dob: DateTime.parse(_dob.text),
          address: _address.text,
          isUpdate: _isUpdate,
        );

        await karyawanRepository.addNewKaryawan(newKaryawan);
      } else {
        // Handle registration failure
        Get.back();
        Get.snackbar('Error', 'Gagal menambahkan data karyawan!');
        return;
      }
    }

    Get.back();
    Get.snackbar(
        'Success',
        _isUpdate
            ? 'Karyawan updated successfully.'
            : 'Karyawan added successfully.');
    Get.offAll(() => const KaryawanPage());
  }
}
