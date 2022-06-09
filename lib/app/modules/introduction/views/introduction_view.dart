import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Berinteraksi dengan mudah",
            body: "Kamu perlu dirumah saja untuk menambahkan teman baru.",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/main-laptop-duduk.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "Temukan sahabat baru",
            body: "Temukan teman baru dimanapun kamu berada",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/ojek.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "Aplikasi bebas biaya",
            body: "Kamu tenang saja, aplikasi ini bebas biaya apapun",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/payment.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "gabung sekarang juga",
            body: "Daftarkan diri kamu untuk menjadi bagian dari kami",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/register.json'),
              ),
            ),
          ),
        ],
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        showSkipButton: true,
        skip: const Text("Skip", style: TextStyle(fontWeight: FontWeight.bold)),
        next: const Text("Next", style: TextStyle(fontWeight: FontWeight.bold)),
        done:
            const Text("Login", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}