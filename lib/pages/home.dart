import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/simple_icons.dart';
import 'package:vaultz/controllers/bottom_tab_controller.dart';
import 'package:vaultz/controllers/route_controller.dart';
import 'package:vaultz/modals/FolderModal.dart';
import 'package:vaultz/pages/cloud/cloudHome.dart';
// icons
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa6_regular.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:vaultz/pages/cloud/directory/cloudFolderView.dart';
import 'package:vaultz/pages/more.dart';
import 'package:vaultz/pages/trash/trashHome.dart';

class VaultzHome extends StatefulWidget {
  const VaultzHome({super.key});

  static const routeName = '/home';

  @override
  State<VaultzHome> createState() => _VaultzHomeState();
}

class _VaultzHomeState extends State<VaultzHome> {
  final VaultzRouteController route = Get.find<VaultzRouteController>();
  var mini = false;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;

  Widget _getNavigatedWidget(int pos) {
    switch (pos) {
      case 0:
        return const CloudHomePage();
      case 2:
        return const TrashHome();
      case 3:
        return const VaultzMorePage();
      default:
        return Center(
          child: Text(
            "Page Not avaialble",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
    }
  }

  void updateNavPos(int index) {
    Get.find<BottomTabController>().updateTabIndex(index);
  }

  void newFolderModal() => Get.dialog(FolderModal());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GetBuilder<BottomTabController>(
          builder: (controller) => Scaffold(
                body: Navigator(onGenerateRoute: (RouteSettings settings) {
                  return GetPageRoute(
                      settings: settings,
                      page: () {
                        final args = settings.arguments as dynamic;
                        switch (settings.name) {
                          case FolderViewPage.routeName:
                            return FolderViewPage(
                              folderID: args['id'],
                              folderName: args['name'],
                            );
                          default:
                            return GetBuilder<BottomTabController>(
                                builder: (controller) => _getNavigatedWidget(
                                    controller.selectedIndex));
                        }
                      });
                }),
                floatingActionButton: controller.selectedIndex == 0
                    ? SpeedDial(
                        backgroundColor: const Color.fromARGB(255, 238, 76, 54),
                        icon: Icons.add,
                        activeIcon: Icons.close,
                        childPadding: const EdgeInsets.all(5),
                        children: [
                          SpeedDialChild(
                              backgroundColor: Colors.redAccent,
                              label: 'Upload File',
                              child: const Iconify(Mdi.cloud_upload_outline,
                                  color: Colors.white),
                              onTap: () => Get.toNamed('/upload')),
                          SpeedDialChild(
                              onTap: newFolderModal,
                              backgroundColor: Colors.green,
                              label: 'New Folder',
                              child: const Iconify(
                                  MaterialSymbols.create_new_folder_outline,
                                  color: Colors.white))
                        ],
                      )
                    : Container(),
                bottomNavigationBar: NavigationBarTheme(
                    data: const NavigationBarThemeData(),
                    child: NavigationBar(
                        selectedIndex: controller.selectedIndex,
                        onDestinationSelected: controller.updateTabIndex,
                        destinations: [
                          const NavigationDestination(
                              icon: Icon(Icons.cloud_circle),
                              label: "My Cloud"),
                          const NavigationDestination(
                              icon: Icon(Icons.history), label: "Recent"),
                          const NavigationDestination(
                              icon: Iconify(Fa6Regular.trash_can),
                              label: "Trash"),
                          const NavigationDestination(
                              icon: Icon(Icons.more_vert), label: "More")
                        ])),
              )),
      onWillPop: () async {
        route.setNotify(true);
        if (route.activeContexts.isNotEmpty) {
          Navigator.pop(route.activeContexts.last);
          route.removeLastActiveContext();
          if (route.activeContexts.isEmpty) {
            route.homePage(true, shouldNotify: false);
          }
        }
        return route.isHomePage && route.shouldNotify;
      },
    );
  }
}
