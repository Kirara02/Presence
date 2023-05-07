import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  const DetailPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Presensi'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    DateFormat.yMMMMEEEEd()
                        .format(DateTime.parse(data['date'])),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Masuk',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Jam :${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}",
                ),
                Text(
                  "Posisi: ${data['masuk']!['lat']}, ${data['masuk']!['long']}",
                ),
                Text(
                  'Status: ${data['masuk']!['status']}',
                ),
                Text(
                  'Address: ${data['masuk']!['address']}',
                ),
                Text(
                  'Jarak: ${data['masuk']!['distance'].toString().split('.').first} Meter',
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Keluar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data['keluar']?['date'] == null
                      ? "Jam: -"
                      : "Jam: ${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}",
                ),
                Text(
                  data['keluar']?['lat'] == null &&
                          data['keluar']?['long'] == null
                      ? "Posisi: -"
                      : "Posisi: ${data['keluar']!['lat']}, ${data['keluar']!['long']}",
                ),
                Text(
                  data['keluar']?['status'] == null
                      ? "Status: -"
                      : "Status: ${data['keluar']['status']}",
                ),
                Text(
                  data['keluar']?['address'] == null
                      ? "Address: -"
                      : 'Address: ${data['keluar']?['address']}',
                ),
                Text(
                  data['keluar']?['distance'] == null
                      ? "Jarak: -"
                      : 'Jarak: ${data['keluar']?['distance'].toString().split('.').first} Meter',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
