import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absensi_pt_bulog/domain/repositories/auth_repository.dart';
import 'package:flutter_absensi_pt_bulog/helper/sharedpreferences.dart';
import 'package:flutter_absensi_pt_bulog/page/admin/admin_page.dart';
import 'package:flutter_absensi_pt_bulog/page/user/user_page.dart';
import 'package:flutter_absensi_pt_bulog/style/style.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthRepository authRepository = Get.find<AuthRepository>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      DataSharedPreferences().readInt("is_admin").then((value) {
        if (value == 1) {
          Get.to(() => const AdminPage());
        } else if (value == 0) {
          Get.to(() => const UserPage());
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/app_logo.png",
              scale: 2,
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "Absensi PT. BULOG",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 50,
                right: 50,
                top: 50,
              ),
              child: _isLoading
                  ? const CupertinoActivityIndicator()
                  : Column(
                      children: [
                        TextField(
                          controller: _email,
                          decoration: Style().dekorasiInput(
                            hint: "email",
                            icon: const Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: Style().dekorasiInput(
                            hint: "password",
                            icon: const Icon(Icons.vpn_key),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_email.text.isEmpty || _password.text.isEmpty) {
                              Get.snackbar(
                                "Maaf",
                                "Harap Lengkapi Email dan Password Anda",
                              );
                            } else {
                              authRepository
                                  .signInWithEmailAndPassword(
                                      _email.text, _password.text)
                                  .then((user) {
                                if (user != null) {
                                  debugPrint(
                                      'email user adalah berikut : ${user.name}');
                                  DataSharedPreferences().saveString(
                                    "id",
                                    user.idUser ?? '',
                                  );
                                  DataSharedPreferences().saveInt(
                                    "is_admin",
                                    user.isAdmin! ? 1 : 0,
                                  );
                                  DataSharedPreferences().saveString(
                                    "name",
                                    user.name ?? '',
                                  );
                                  if (user.isAdmin!) {
                                    Get.offAll(() => const AdminPage());
                                  } else {
                                    Get.offAll(() => const UserPage());
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Maaf"),
                                        content: const Text(
                                            "Email/Password anda tidak sesuai!"),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              });
                            }
                          },
                          child: const Text("LOGIN"),
                        )
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
