


import 'package:chat/core/others/base_viewModel.dart';

class BottomNavigationViewmodel extends BaseViewmodel {
  int _currentIndex = 1;

  int get currentIndex => _currentIndex;

  void setIndex(int value) {
    if (value >= 0 && value < 3 && _currentIndex != value) {
      _currentIndex = value;
      notifyListeners();
    }
  }
}