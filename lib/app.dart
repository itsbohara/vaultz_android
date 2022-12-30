import 'package:vaultz/controllers/settings_controller.dart';
// import 'package:vaultz/pages/auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultz/pages/auth/login.dart';
// import 'package:vaultz/pages/auth/register.dart';
import 'package:vaultz/boot.dart';
import 'package:vaultz/pages/auth/vaultLogin.dart';
import 'package:vaultz/pages/cloud/directory/cloudFolderView.dart';
import 'package:vaultz/pages/home.dart';
import 'package:vaultz/pages/upload/fileUpload.dart';

/// The Widget that configures your application.
class Application extends StatelessWidget {
  const Application({
    super.key,
    // required this.settingsController,
  });

  // final SettingsController settingsController;
  // final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    // return AnimatedBuilder( animation: settingsController,
    return GetBuilder<SettingsController>(
      builder: (settingsController) {
        return GetMaterialApp(
          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          // onGenerateTitle: (BuildContext context) =>
          //     AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
              primarySwatch: Colors.blue,
              appBarTheme: AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87)),
          // darkTheme: ThemeData.dark(useMaterial3: true),
          darkTheme: ThemeData(
              //   primaryColor: Colors.redAccent,
              //   // cardColor: Colors.black,
              //   cardTheme: CardTheme(color: Colors.black87),
              //   textTheme: TextTheme(
              //     headline1: TextStyle(color: Colors.white.withOpacity(0.9)),
              //     headline2: TextStyle(color: Colors.white.withOpacity(0.9)),
              //     bodyText2: TextStyle(color: Colors.white.withOpacity(0.9)),
              //     subtitle1: TextStyle(color: Colors.white.withOpacity(0.9)),
              //   ),
              // TODO: bottom nav bar theme setup
              // bottomNavigationBarTheme: BottomNavigationBarThemeData(),
              brightness: Brightness.dark,
              appBarTheme: AppBarTheme(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white)),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                final args = routeSettings.arguments as dynamic;
                switch (routeSettings.name) {
                  // case OnBoarding.routeName:
                  //   return const OnBoarding();
                  case LoginPage.routeName:
                    return const LoginPage();
                  case VautlzLoginPage.routeName:
                    return const VautlzLoginPage();
                  // case RegisterPage.routeName:
                  //   return const RegisterPage();
                  case VaultzHome.routeName:
                    return VaultzHome();

                  case FileUploadPage.routeName:
                    return FileUploadPage();
                  case "/boot":
                    return const Boot();
                  default:
                    return const Boot();
                }
              },
            );
          },
        );
      },
    );
  }
}
