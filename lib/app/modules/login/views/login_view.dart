import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              autocorrect: false,
              controller: controller.emailC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              autocorrect: false,
              obscureText: true,
              controller: controller.passC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "password",
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.login();
                  }
                },
                child: Text(
                  controller.isLoading.isFalse ? "LOGIN" : "Loading...",
                ),
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
              child: const Text("Lupa password ?"),
            )
          ],
        ));
  }
}
