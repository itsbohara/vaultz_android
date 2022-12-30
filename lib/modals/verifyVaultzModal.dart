import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/controllers/file.controller.dart';
import 'package:vaultz/controllers/vaultz_controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class VerifyVaultzModal extends StatefulWidget {
  VerifyVaultzModal({
    super.key,
    this.onVerify,
  });

  VoidCallback? onVerify;

  @override
  State<VerifyVaultzModal> createState() => _FolderModalState();
}

class _FolderModalState extends State<VerifyVaultzModal> {
  // bio auth
  final LocalAuthentication bioAuth = LocalAuthentication();
  var auth = Get.find<AuthController>();
  var vaultzController = Get.find<VaultzController>();
  var dirController = Get.find<DirectoryController>();

  final passController = TextEditingController();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    if (auth.bioAuth) Future.microtask(verifyWithBiometric);
  }

  void verifyWithBiometric() async {
    try {
      final bool didAuthenticate = await bioAuth.authenticate(
          localizedReason: 'Please confirm to login to vaultz',
          options: const AuthenticationOptions(biometricOnly: true),
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Biometric authentication required!',
              cancelButton: 'No thanks',
            )
          ]);

      if (didAuthenticate) {
        var loginRes = await vaultzController.loginWithBioAuth();
        if (loginRes.isSuccess) {
          Get.back();
          widget.onVerify!();
        } else {
          showCustomErrorSnackbar(loginRes.message);
        }
      }
    } on PlatformException catch (e) {
      showCustomErrorSnackbar("Bio auth error!");
    }
  }

  Future<void> vaultzLogin() async {
    if (passController.text.trim() == '') return;
    var password = passController.text;
    var loginResult = await vaultzController.login(password);
    if (!loginResult.isSuccess) {
      showCustomErrorSnackbar("Invalid password!");
      passController.text = '';
    }
    Get.back();
    if (loginResult.isSuccess) {
      widget.onVerify!();
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
                  obscureText: !_showPassword,
                  autofocus: true,
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
                auth.bioAuth
                    ? Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: verifyWithBiometric,
                                child: Text("Verify using biometric"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 13))),
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      )
                    : Container(),
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
                        onPressed: vaultzLogin, child: const Text("Verify"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
