import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/controllers/route_controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/fileViewer/FileViewer.dart';
import 'package:vaultz/pages/cloud/SortView.dart';
import 'package:vaultz/pages/cloud/directory/directoryGridView.dart';
import 'package:vaultz/pages/cloud/directory/directoryListView.dart';
import 'package:vaultz/utils/file.dart';
import 'package:vaultz/models/File.model.dart' as VaultzFile;

class FolderViewPage extends StatefulWidget {
  FolderViewPage({super.key, this.folderID, this.folderName});

  String? folderID;
  String? folderName;

  static const routeName = '/folder-view';

  @override
  State<FolderViewPage> createState() => _FolderViewPageState();
}

class _FolderViewPageState extends State<FolderViewPage> {
  final dirController = Get.find<DirectoryController>();
  bool listView = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFolder();
  }

  toggleView() => setState(() => listView = !listView);

  Future<void> loadFolder() async {
    await Get.find<DirectoryController>().getFolder(widget.folderID!);
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      print("loading dir ${widget.folderID}");
      Get.find<VaultzRouteController>().addActiveContext(context);
      dirController.addActiveDir(widget.folderID!);
    });
    return Scaffold(
        appBar: AppBar(title: Text(widget.folderName!)),
        body: GetBuilder<DirectoryController>(builder: (dir) {
          if (dir.isLoading) return const LinearProgressIndicator();

          bool isEmpty = dir.folders.isEmpty && dir.files.isEmpty;

          if (isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/vaultz_empty.png'),
                  const Text(
                    "This folder is empty",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
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
                RefreshIndicator(
                    onRefresh: loadFolder,
                    child: listView
                        ? DirectoryListView(
                            folderID: widget.folderID!,
                          )
                        : DirectoryGridView(folderID: widget.folderID!)),
              ],
            ),
          );
        }));
  }
}
