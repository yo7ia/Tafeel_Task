import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';

class UserState extends Equatable {
  final List<UserModel> users;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final int totalPages;
  final String? error;

  const UserState({
    this.users = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalPages = 1,
    this.error,
  });

  UserState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    int? totalPages,
    String? error,
  }) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    users,
    isLoading,
    hasMore,
    currentPage,
    totalPages,
    error,
  ];
}
