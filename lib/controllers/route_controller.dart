import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VaultzRouteController extends GetxController {
  bool _homeActive = true;
  bool get isHomePage => _homeActive;

  bool _notify = true;
  bool get shouldNotify => _notify;

  BuildContext? _activeContext;
  BuildContext? get activeContext => _activeContext;

  List<BuildContext> _activeContexts = [];
  List<BuildContext> get activeContexts => _activeContexts;

  void homePage(bool mode, {bool shouldNotify = true}) {
    _homeActive = mode;
    _notify = shouldNotify;
    update();
  }

  void addActiveContext(BuildContext context) {
    if (_homeActive) _homeActive = false;
    _activeContexts.add(context);
    _activeContext = context;
    update();
  }

  void removeLastActiveContext() {
    _activeContexts.removeLast();
    _activeContext = _activeContexts.isNotEmpty ? _activeContexts.last : null;
    update();
  }

  void setNotify(bool notify) {
    _notify = notify;
    update();
  }
}
