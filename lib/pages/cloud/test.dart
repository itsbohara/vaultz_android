import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // Text(
              //   "👋🏻 Hello ${authController.user!.name},",
              //   style:
              //       const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              // ),
              Text(
                "Welcome to Vaultz",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 60),
              Text(
                textAlign: TextAlign.center,
                "File uploading test first",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              // ElevatedButton(
              //     onPressed: () => Get.toNamed("/file-viewer"),
              //     child: Text("Decrypt & View File"))
            ],
          ),
        ),
      ),
    );
  }
}
