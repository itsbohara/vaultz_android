import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomErrorSnackbar(String message,
    {bool isError = true, String title = "Error"}) {
  // Get.snackbar(
  //   "GeeksforGeeks",
  //   "Hello everyone",
  //   // icon: Icon(Icons.person, color: Colors.white),
  //   // snackPosition: SnackPosition.BOTTOM,
  // );
  Get.snackbar(title, message,
      icon: Icon(Icons.error, color: Colors.white),
      colorText: Colors.white,
      // snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent);
}

void showSuccessSnackbar(String message,
    {bool isError = true, String title = "Success"}) {
  Get.snackbar(title, message,
      icon: Icon(Icons.error, color: Colors.white),
      colorText: Colors.white,
      backgroundColor: Colors.greenAccent);
}
