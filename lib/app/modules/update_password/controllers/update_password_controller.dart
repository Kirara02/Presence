import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currC = TextEditingController(text: "");
  TextEditingController newC = TextEditingController(text: "");
  TextEditingController confC = TextEditingController(text: "");

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> updatePass() async {
    if (currC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confC.text.isNotEmpty) {
      isLoading.value = true;
      if (newC.text == confC.text) {
        try {
          String email = auth.currentUser!.email!;
          await auth.signInWithEmailAndPassword(
            email: email,
            password: currC.text,
          );
          await auth.currentUser!.updatePassword(newC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: email,
            password: newC.text,
          );

          Get.back();
          Get.snackbar("Berhasil", "Password berhasil diupdate");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar("Terjadi Kesalahan", "Password yg dimasukan salah");
          } else {
            Get.snackbar("Terjadi Kesalahan", e.code.toLowerCase());
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Tidak dapat update password");
        } finally {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Confirm password tidak cocok");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Semua field tidak boleh kosong");
    }
  }
}
