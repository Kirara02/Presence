import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  const DetailPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                    DateFormat.yMMMMEEEEd().format(DateTime.now()),
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
                  "Jam :${DateFormat.jms().format(DateTime.now())}",
                ),
                const Text(
                  "Posisi : -6.3262865, 187.781926",
                ),
                Text(
                  "Status: Di dalam area",
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
                  "Jam :${DateFormat.jms().format(DateTime.now())}",
                ),
                Text(
                  "Posisi : -6.3262865, 187.781926",
                ),
                Text(
                  "Status: Di dalam area",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
