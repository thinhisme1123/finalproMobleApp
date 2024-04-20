// Controllers
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  void updateProfile(String name, String email, String phone) {
    nameController.text = name;
    emailController.text = email;
    phoneController.text = phone;
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

}