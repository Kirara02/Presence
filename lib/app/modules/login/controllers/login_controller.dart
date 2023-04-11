import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController(text: "");
  TextEditingController passC = TextEditingController(text: "");

  FirebaseAuth authentication = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        UserCredential credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );
        print(credential);
        if (credential.user != null) {
          if (credential.user!.emailVerified == true) {
            if (passC.text == 'password') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: "Belum verifikasi",
              middleText:
                  "Kamu belum verifikasi email ini!. Lakukan verifikasi diemail kamu",
              actions: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await credential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar(
                        "Berhasil",
                        "Kami telah berhasil mengirim verifikasi email ke akun kamu!",
                      );
                    } catch (e) {
                      Get.snackbar(
                        "Terjadi Kesalahan",
                        "Tidak dapat mengirim email verifikasi. Hubungi admin atau CS",
                      );
                    }
                  },
                  child: const Text("KIRIM ULANG"),
                )
              ],
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi Kesalahan", "Email tidak terdaftar");
        } else if (e.code == 'invalid-email') {
          Get.snackbar("Terjadi Kesalahan", "Email harus benar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password salah");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login.");
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Email dan password harius diisi.",
      );
    }
  }

  void forgotPassword() {}
}
