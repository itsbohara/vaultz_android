import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:vaultz/controllers/file.controller.dart';
import 'package:vaultz/utils/file.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';

class SortViewMenu extends StatelessWidget {
  SortViewMenu({Key? key}) : super(key: key);
  final fileController = Get.find<FileController>();

  @override
  Widget build(BuildContext context) {
    // bool isDarkTheme = Get.isDarkMode;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkTheme ? Colors.black : Colors.white.withOpacity(0.96),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Sort By"),
          ),
          const Divider(height: 2),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                    onTap: () => {},
                    leading: Icon(Icons.arrow_upward_rounded),
                    title: Text("Name")),
                ListTile(
                    onTap: () => {},
                    leading: Icon(Icons.arrow_upward_rounded),
                    title: Text("Size")),
                ListTile(
                    onTap: () => {},
                    leading: Icon(Icons.arrow_upward_rounded),
                    title: Text("Last Modified")),
                ListTile(
                    onTap: () => {},
                    leading: Icon(Icons.arrow_upward_rounded),
                    title: Text("Last Opened")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
