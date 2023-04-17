import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    pageIndex.value = i;
    switch (i) {
      case 1:
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse['error'] != true) {
          Position position = dataResponse['position'];
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          String address =
              "${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";

          await updatePosition(position, address);

          // cek distance between 2 position
          double distance = Geolocator.distanceBetween(
            -7.3215497,
            108.0306286,
            position.latitude,
            position.longitude,
          );

          print(distance);
          // presensi
          await presensi(position, address, distance);

          Get.snackbar(
            "Berhasil",
            "Kamu telah berhasil mengisi daftar hadir",
          );
        } else {
          Get.snackbar("Terjadi kesalahan", dataResponse['message']);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;

    await firestore.collection('pegawai').doc(uid).update({
      'position': {
        'lat': position.latitude,
        'lang': position.longitude,
      },
      'address': address
    });
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        firestore.collection('pegawai').doc(uid).collection('presence');

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = 'Di Luar Area';

    if (distance <= 200) {
      status = 'Di Dalam Area';
    }

    if (snapPresence.docs.isEmpty) {
      await colPresence.doc(todayDocID).set({
        'date': now.toIso8601String(),
        'masuk': {
          'date': now.toIso8601String(),
          'lat': position.latitude,
          'long': position.longitude,
          'address': address,
          'status': status
        },
      });
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocID).get();

      if (todayDoc.exists == true) {
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?['keluar'] != null) {
          Get.snackbar("Sukses",
              "Kamu telah absen masuk & keluar dan kamu tidak dapat absen kembali hari ini");
        } else {
          await colPresence.doc(todayDocID).update({
            'keluar': {
              'date': now.toIso8601String(),
              'lat': position.latitude,
              'long': position.longitude,
              'address': address,
              'status': status
            },
          });
          Get.snackbar("Sukses", "Kamu berhasil absen keluar");
        }
      } else {
        await colPresence.doc(todayDocID).set({
          'date': now.toIso8601String(),
          'masuk': {
            'date': now.toIso8601String(),
            'lat': position.latitude,
            'long': position.longitude,
            'address': address,
            'status': status
          },
        });
      }
    }
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        'message': 'Tidak dapat mengambil GPS dari device ini',
        'error': true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          'message': 'Izin menggunakan GPS ditolak.',
          'error': true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        'message':
            'Settingan hp kamu tidak memperbolehkan untuk mengakses GPS. Ubah pada settingan hp kamu.',
        'error': true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      'position': position,
      'message': 'Berhasil mendapatkan posisi device.',
      'error': false,
    };
  }
}
