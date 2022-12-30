import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:vaultz/controllers/settings_controller.dart';
import 'package:vaultz/controllers/vaultz_controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/pages/home.dart';
import 'package:vaultz/utils/validator.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class VautlzLoginPage extends StatefulWidget {
  const VautlzLoginPage({super.key});

  static const routeName = '/vaultzlogin';

  @override
  State<VautlzLoginPage> createState() => _VautlzLoginPageState();
}

class _VautlzLoginPageState extends State<VautlzLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  final passwordController = TextEditingController();
  final auth = Get.find<AuthController>();

  // bio auth
  final LocalAuthentication bioAuth = LocalAuthentication();
  var vaultzController = Get.find<VaultzController>();

  Future<void> _handleVaultzLogin() async {
    if (!_formKey.currentState!.validate()) return;

    var password = passwordController.text;

    var loginResult = await vaultzController.login(password);
    if (loginResult.isSuccess) {
      Get.offAndToNamed('/home');
    } else {
      showCustomErrorSnackbar(loginResult.message);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(loginWithBiometric);
  }

  void loginWithBiometric() async {
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
          Get.offAndToNamed('/home');
        } else {
          showCustomErrorSnackbar(loginRes.message);
        }
      }
    } on PlatformException catch (e) {
      print(e.code);
      print("Bio auth error here");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme = Get.find<SettingsController>().isDarkMode;
    return Scaffold(
        // backgroundColor: isDarkTheme ? Colors. : Colors.blueGrey[200],
        body: Form(
            key: _formKey,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.85,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? Colors.black54 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Center(
                          child: Text(
                            "Verify Vaultz",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: const Text(
                            "Zero Knowledge Cloud File Storage Vaultz",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        TextFormField(
                          obscureText: !_showPassword,
                          validator: (value) =>
                              Validator.validatePassword(value ?? ""),
                          controller: passwordController,
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
                            hintText: "Password",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        const Text(
                          "Your vautlz is locked. Confirm to continue.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: size.height * 0.06),
                        auth.bioAuth
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            onPressed: loginWithBiometric,
                                            child:
                                                Text("Unlock with biometric"),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.indigo,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40,
                                                        vertical: 13))),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GetBuilder<AuthController>(
                                  builder: (_authController) {
                                return ElevatedButton(
                                  onPressed: _authController.isLoading
                                      ? null
                                      : _handleVaultzLogin,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 13)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _authController.isLoading
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(width: 10),
                                      Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
