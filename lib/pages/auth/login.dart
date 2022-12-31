import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:vaultz/controllers/settings_controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/pages/home.dart';
import 'package:vaultz/utils/validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    var loginController = Get.find<AuthController>();

    var email = emailController.text;
    var password = passwordController.text;

    var loginResult = await loginController.loginUser(email, password);
    // loginResult.isSuccess
    // if (loginResult.isSuccess) Navigator.of(context).pop();
    if (loginResult.isSuccess) {
      // await loginController.getCurrentUser();
      // Get.until((route) => Get.currentRoute == '/home');
      // Get.offAllNamed('/home');
      Get.offAllNamed('/boot');
    }
    if (!loginResult.isSuccess) {
      if (loginResult.message == "Verify") {
        Get.toNamed("/verify");
      } else
        showCustomErrorSnackbar(loginResult.message);
    }
    ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                            "Login to Vaultz",
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
                          validator: (value) =>
                              Validator.validateEmail(value ?? ""),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
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
                        SizedBox(height: size.height * 0.06),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GetBuilder<AuthController>(
                                  builder: (_authController) {
                                return ElevatedButton(
                                  onPressed: _authController.isLoading
                                      ? null
                                      : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New to Vaultz ?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () => Get.toNamed('/register'),
                                child: Text('Register Now'))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
