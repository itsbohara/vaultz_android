import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:vaultz/controllers/vaultz_controller.dart';

class Boot extends StatefulWidget {
  const Boot({super.key});

  static const routeName = '/';

  @override
  State<Boot> createState() => _BootState();
}

class _BootState extends State<Boot> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAuthUser();
  }

  Future<void> initAuthUser() async {
    final authController = Get.find<AuthController>();
    await authController.initAuthUser();
    if (!authController.isAuthorized) {
      Get.offAndToNamed('/login');
      return;
    }

    if (authController.isAuthorized) {
      final vaultzController = Get.find<VaultzController>();
      if (!vaultzController.isAuthorized) {
        Get.offAndToNamed('/vaultzlogin');
        return;
      }
    }

    Get.offAndToNamed('/home');
  }

  Widget VaultzLogo() {
    return Container(
      child: Image.asset('assets/logo/vaultz.png',
          width: MediaQuery.of(context).size.width * 0.22),
    );
  }

  Widget _Vaultz() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        VaultzLogo(),
        SizedBox(height: 30),
        Text("Vaultz Cloud",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w500))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _Vaultz()),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 50),
            // CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
