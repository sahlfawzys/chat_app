import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangeProfileController extends GetxController {
  //TODO: Implement ChangeProfileController

  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;

  @override
  void onInit() {
    // TODO: implement onInit
    emailC = TextEditingController();
    nameC = TextEditingController();
    statusC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    nameC.dispose();
    statusC.dispose();
    super.onClose();
  }
}
