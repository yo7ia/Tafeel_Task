import '../models/user_model.dart';
import '../models/user_response_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  Future<UserResponseModel> fetchUsers(int page) async {
    final data = await _apiService.getUsers(page);
    return UserResponseModel.fromJson(data);
  }

  Future<UserModel> fetchUserDetails(int id) async {
    final data = await _apiService.getUserById(id);
    return UserModel.fromJson(data['data']);
  }
}
