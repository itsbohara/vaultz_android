import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa6_regular.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/pages/cloud/SortView.dart';
import 'package:vaultz/pages/trash/trashGridView.dart';
import 'package:vaultz/pages/trash/trashListView.dart';

class TrashHome extends StatefulWidget {
  const TrashHome({super.key});

  @override
  State<TrashHome> createState() => _TrashHomeState();
}

class _TrashHomeState extends State<TrashHome> {
  final dirController = Get.find<DirectoryController>();
  bool listView = true;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTrash();
  }

  Future<void> loadTrash() async {
    await Get.find<DirectoryController>().getTrashRoot();
  }

  toggleView() => setState(() => listView = !listView);

  void handleEmptyTrash(ctx) async {
    await dirController.clearTrash();
    Navigator.pop(ctx);
  }

  emptyTrash() {
    showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete forever?'),
          content: Text(
              'All trashed folder & files will be deleted forever. Are you surce ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete forever'),
              onPressed: () => !loading ? handleEmptyTrash(context) : null,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trash"),
        actions: [
          IconButton(
              onPressed: emptyTrash, icon: Icon(Icons.delete_forever_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ListTile(
              tileColor: Color.fromARGB(39, 238, 53, 53),
              leading: Iconify(Fa6Regular.trash_can),
              title: Text("Items in trash are deleted forever after 60 days.",
                  style: TextStyle(fontSize: 13)),
            ),
            GetBuilder<DirectoryController>(builder: (dir) {
              if (dir.isLoading) return const LinearProgressIndicator();

              bool isEmpty = dir.folders.isEmpty && dir.files.isEmpty;
              if (isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/trash.png', height: 270),
                      const Text(
                        "Nothing in trash",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }

              return Column(
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
                              : Icons.format_list_bulleted)),
                    ],
                  ),
                  RefreshIndicator(
                      onRefresh: loadTrash,
                      child: listView
                          ? TrashListView(
                              folderID: "widget.folderID!",
                            )
                          : TrashGridView(folderID: "widget.folderID!"))
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
