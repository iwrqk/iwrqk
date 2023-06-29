import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateThreadController extends GetxController {
  CreateThreadController();

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  late String channelName;

  @override
  void onInit() {
    super.onInit();
    channelName = Get.arguments!;
  }
}
