import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/models/File.model.dart' as VaultzFile;
import 'package:vaultz/modules/cloud/file.dart';
import 'package:vaultz/modules/cloud/FileMoreMenu.dart';
import 'package:vaultz/pages/cloud/SortView.dart';
import 'package:vaultz/pages/cloud/directory/cloudFolderView.dart';
import 'package:vaultz/pages/cloud/gridView.dart';
import 'package:vaultz/pages/cloud/listView.dart';
import 'package:vaultz/utils/file.dart';

class CloudHomePage extends StatefulWidget {
  const CloudHomePage({super.key});

  @override
  State<CloudHomePage> createState() => _CloudHomePageState();
}

class _CloudHomePageState extends State<CloudHomePage> {
  final authController = Get.find<AuthController>();
  bool listView = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCloud();
  }

  Future<void> loadCloud() async {
    await Get.find<DirectoryController>().getMyCloud();
  }

  toggleView() => setState(() => listView = !listView);

  void logout() async {
    await authController.logoutUser();
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Vaultz Cloud"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => Get.bottomSheet(SortViewMenu()),
                    child: Row(
                      children: const [
                        Text(
                          "Last Modified",
                          style: TextStyle(color: Colors.black87),
                        ),
                        Icon(
                          Icons.arrow_downward,
                          color: Colors.black54,
                          size: 17,
                        )
                      ],
                    )),
                IconButton(
                    onPressed: toggleView,
                    icon: Icon(listView
                        ? Icons.grid_view_rounded
                        : Icons.format_list_bulleted))
              ],
            ),
            // Flexible(child:
            GetBuilder<DirectoryController>(builder: (dir) {
              if (dir.isLoading) return const LinearProgressIndicator();
              return RefreshIndicator(
                  onRefresh: loadCloud,
                  child: listView ? CloudListView() : CloudGridView());
            }),
          ],
        ),
      )),
    );
  }
}
