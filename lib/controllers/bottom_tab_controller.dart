import 'package:get/get.dart';

class BottomTabController extends GetxController {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void updateTabIndex(int index, {bool shouldNotify = false}) {
    if (index == _selectedIndex) return;
    _selectedIndex = index;
    update();
  }
}
