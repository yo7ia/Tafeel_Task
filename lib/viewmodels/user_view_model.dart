import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../models/user_response_model.dart';
import '../repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  List<UserModel> users = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  int totalPages = 1;

  Future<void> fetchUsers() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final UserResponseModel response = await _repository.fetchUsers(
        currentPage,
      );

      totalPages = response.totalPages;

      if (response.users.isEmpty || currentPage > totalPages) {
        hasMore = false;
      } else {
        users.addAll(response.users);
        currentPage = response.page + 1;
      }
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshUsers() async {
    users.clear();
    currentPage = 1;
    hasMore = true;
    notifyListeners();
    await fetchUsers();
  }
}
