import 'package:equatable/equatable.dart';
import 'package:tafeel_task/models/user_model.dart';

class UserDetailState extends Equatable {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  const UserDetailState({this.isLoading = false, this.user, this.error});

  UserDetailState copyWith({bool? isLoading, UserModel? user, String? error}) {
    return UserDetailState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, user, error];
}
