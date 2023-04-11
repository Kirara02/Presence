// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameC = TextEditingController(text: "");
  TextEditingController nipC = TextEditingController(text: "");
  TextEditingController emailC = TextEditingController(text: "");

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPegawai() async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nipC.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          await firestore.collection('pegawai').doc(uid).set({
            'nip': nipC.text,
            'name': nameC.text,
            'email': emailC.text,
            'uid': uid,
            'created_at': DateTime.now().toIso8601String()
          });

          await userCredential.user!.sendEmailVerification();
        }

        print(userCredential);
      } on FirebaseAuthException catch (e) {
        print(e.code);
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
        }
      } catch (e) {
        Get.snackbar(
          "Terjadi kesalahan",
          "Tidak dapat menambahkan pegawai.",
        );
      }
    } else {
      Get.snackbar(
        "Terjadi kesalahan",
        "Nip, nama, dan email tidak boleh kosong",
      );
    }
  }
}
