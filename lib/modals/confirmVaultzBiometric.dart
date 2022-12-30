import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/controllers/file.controller.dart';
import 'package:vaultz/controllers/vaultz_controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class ConfirmVaultzBiometric extends StatefulWidget {
  ConfirmVaultzBiometric({
    super.key,
    this.onVualtzAuthenticate,
  });

  Function? onVualtzAuthenticate; // for bio auth enabling

  @override
  State<ConfirmVaultzBiometric> createState() => _ModalState();
}

class _ModalState extends State<ConfirmVaultzBiometric> {
  var auth = Get.find<AuthController>();

  // bio auth
  final LocalAuthentication bioAuth = LocalAuthentication();
  late bool bioSupported;

  var vaultzController = Get.find<VaultzController>();
  var dirController = Get.find<DirectoryController>();

  final passController = TextEditingController();
  FocusNode passFocusNode = FocusNode();
  bool _showPassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkBiometricAuth();
  }

  checkBiometricAuth() async {
    await checkBioSupport();
    if (!bioSupported) {
      showCustomErrorSnackbar(
          "Your device isn't compatible or bio init failed!");
      Navigator.pop(context);
      return;
    }
    passFocusNode.requestFocus();
  }

  Future<void> vaultzLogin() async {
    if (passController.text.trim() == '') return;
    var password = passController.text;
    var loginResult = await vaultzController.login(password);
    if (!loginResult.isSuccess) {
      showCustomErrorSnackbar("Invalid password!");
      passController.text = '';
      return;
    }
    Get.back();
    if (loginResult.isSuccess) {
      widget.onVualtzAuthenticate!(password);
    }
  }

  verifyWithBiometric() async {
    try {
      final bool didAuthenticate = await bioAuth.authenticate(
          localizedReason: 'Please confirm to setup biometric login',
          options: const AuthenticationOptions(biometricOnly: true),
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Biometric authentication required!',
              cancelButton: 'No thanks',
            )
          ]);

      if (didAuthenticate) {
        vaultzLogin();
      }
    } on PlatformException catch (e) {
      print(e.code);
      print("Bio auth error here");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Confirm Vaultz Password",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text("Verify your vaultz to proceed"),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  focusNode: passFocusNode,
                  obscureText: !_showPassword,
                  controller: passController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                      child: Icon(
                        !_showPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: "Vaulz Password",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.redAccent),
                        )),
                    SizedBox(width: 10),
                    TextButton(
                        onPressed: verifyWithBiometric,
                        child: const Text("Verify"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future checkBioSupport() async {
    final bool canAuthenticateWithBiometrics = await bioAuth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await bioAuth.isDeviceSupported();
    setState(() => bioSupported = canAuthenticate);
  }
}
