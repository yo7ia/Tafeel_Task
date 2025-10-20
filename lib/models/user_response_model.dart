import 'user_model.dart';

class UserResponseModel {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<UserModel> users;

  UserResponseModel({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.users,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> userList = json['data'] ?? [];
    return UserResponseModel(
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
      users: userList.map((e) => UserModel.fromJson(e)).toList(),
    );
  }
}
