// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAdd = false.obs;
  TextEditingController nameC = TextEditingController(text: "");
  TextEditingController nipC = TextEditingController(text: "");
  TextEditingController emailC = TextEditingController(text: "");
  TextEditingController passC = TextEditingController(text: "");

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
  
    if (passC.text.isNotEmpty) {
      isLoadingAdd.value = true;
      try {
        String emailAdmin = firebaseAuth.currentUser!.email!;

        UserCredential adminCredential =
            await firebaseAuth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passC.text,
        );

        UserCredential pegawaiCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;
          await firestore.collection('pegawai').doc(uid).set({
            'nip': nipC.text,
            'name': nameC.text,
            'email': emailC.text,
            'uid': uid,
            'created_at': DateTime.now().toIso8601String()
          });

          await pegawaiCredential.user!.sendEmailVerification();
          await firebaseAuth.signOut();

          UserCredential adminCredential =
              await firebaseAuth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passC.text,
          );

          Get.back();
          Get.back();
          Get.snackbar("Berhasil", "Pegawai berhasil ditambahkan");
        }
        isLoadingAdd.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingAdd.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar(
            "Terjadi kesalahan",
            "Password yang digunakan terlalu lemah",
          );
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar(
            "Terjadi kesalahan",
            "Email ini sudah terdaftar",
          );
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
            "Terjadi kesalahan",
            "Tidak dapat mengverifikasi. Password salah",
          );
        } else {
          Get.snackbar("Terjadi Kesalahan", e.code);
        }
      } catch (e) {
        isLoadingAdd.value = false;
        Get.snackbar(
          "Terjadi kesalahan",
          "Tidak dapat menambahkan pegawai.",
        );
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Password harus diisi");
    }
  }

  Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nipC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: "Validasi Admin",
        content: Column(
          children: [
            const Text("Masukan password untuk validasi admin ! "),
            const SizedBox(
              height: 10,
            ),
            TextField(
              autocorrect: false,
              obscureText: true,
              controller: passC,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            )
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: const Text("CANCEL"),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingAdd.isFalse) {
                  await prosesAddPegawai();
                }
                isLoading.value = false;
              },
              child: Text(isLoadingAdd.isFalse ? "CONFIRM" : "LOADING..."),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar(
        "Terjadi kesalahan",
        "Nip, nama, dan email tidak boleh kosong",
      );
    }
  }
}
