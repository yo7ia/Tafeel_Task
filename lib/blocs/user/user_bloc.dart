import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_response_model.dart';
import '../../repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(const UserState()) {
    on<FetchUsers>(_onFetchUsers);
    on<RefreshUsers>(_onRefreshUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));

    try {
      final UserResponseModel response = await repository.fetchUsers(
        state.currentPage,
      );

      if (response.users.isEmpty || state.currentPage > response.totalPages) {
        emit(state.copyWith(isLoading: false, hasMore: false));
      } else {
        emit(
          state.copyWith(
            users: [...state.users, ...response.users],
            currentPage: response.page + 1,
            totalPages: response.totalPages,
            isLoading: false,
            hasMore: response.page < response.totalPages,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onRefreshUsers(
    RefreshUsers event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserState(isLoading: true));
    try {
      final UserResponseModel response = await repository.fetchUsers(1);
      emit(
        state.copyWith(
          users: response.users,
          currentPage: 2,
          totalPages: response.totalPages,
          hasMore: response.page < response.totalPages,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
