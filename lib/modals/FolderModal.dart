import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/controllers/file.controller.dart';

class FolderModal extends StatefulWidget {
  const FolderModal({super.key});

  @override
  State<FolderModal> createState() => _FolderModalState();
}

class _FolderModalState extends State<FolderModal> {
  var dirController = Get.find<DirectoryController>();

  final nameController = TextEditingController();

  Future<void> createFolder() async {
    if (nameController.text.trim() == '') return;
    var activeDir = dirController.activeFolder;

    var data = <String, String>{"name": nameController.text};
    if (activeDir != null) data['parent'] = activeDir.id!;
    await dirController.createFolder(data);
    if (activeDir != null) {
      await dirController.getFolder(activeDir.id!);
    } else {
      await dirController.getMyCloud();
    }
    Get.back();
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
                  "New Folder",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  autofocus: true,
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Name",
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
                        onPressed: createFolder, child: const Text("Create"))
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
