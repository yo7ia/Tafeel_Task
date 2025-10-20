import 'package:flutter/foundation.dart';

enum UserViewType { list, grid }

class UserListTypeState extends ChangeNotifier {
  UserViewType _viewType = UserViewType.list;

  UserViewType get viewType => _viewType;
  bool get isGrid => _viewType == UserViewType.grid;

  void toggleViewType() {
    _viewType = _viewType == UserViewType.list
        ? UserViewType.grid
        : UserViewType.list;
    notifyListeners();
  }
}
