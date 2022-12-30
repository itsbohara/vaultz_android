import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:vaultz/modals/confirmVaultzBiometric.dart';
import 'package:vaultz/modals/verifyVaultzModal.dart';

class VaultzMorePage extends StatefulWidget {
  const VaultzMorePage({super.key});

  @override
  State<VaultzMorePage> createState() => Vaultz_MorePageState();
}

class Vaultz_MorePageState extends State<VaultzMorePage> {
  final auth = Get.find<AuthController>();

  void logout() async {
    await auth.logoutUser();
    Get.offAllNamed('/login');
  }

  handleBIOAuthChange(bool enable) {
    if (enable) {
      Get.dialog(ConfirmVaultzBiometric(
        onVualtzAuthenticate: (vaultzPass) =>
            auth.updateBioAuth(enable, vaultzPass: vaultzPass),
      ));
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Disable Biometric"),
            content: const Text(
                "Afer removing biometric authentication, vaultz need confirm using password."),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text("Proceed"),
                onPressed: () => auth.updateBioAuth(enable),
              ),
            ],
          );
        },
      );
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: GetBuilder<AuthController>(builder: (auth) {
        return SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
                child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://merotayari.vercel.app/static/mock-images/avatars/avatar_default.jpg'),
            )),
            SizedBox(height: 5),
            Text(
              auth.user?.name ?? "Vaultz User",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 10),
            SwitchListTile(
              value: auth.bioAuth,
              onChanged: handleBIOAuthChange,
              title: Text("Enable Biometric"),
              subtitle: Text("Biometric can be used to verify vaultz login"),
            ),
          ],
        ));
      }),
    );
  }
}
