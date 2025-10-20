import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tafeel_task/repositories/user_repository.dart';

import 'user_details_event.dart';
import 'user_details_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserRepository repository;

  UserDetailBloc(this.repository) : super(const UserDetailState()) {
    on<FetchUserDetail>(_onFetchUserDetail);
  }

  Future<void> _onFetchUserDetail(
    FetchUserDetail event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await repository.fetchUserDetails(event.userId);
      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
