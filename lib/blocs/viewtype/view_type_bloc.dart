import 'package:flutter_bloc/flutter_bloc.dart';

import 'view_type_event.dart';
import 'view_type_state.dart';

class ViewTypeBloc extends Bloc<ViewTypeEvent, ViewTypeState> {
  ViewTypeBloc() : super(const ViewTypeState()) {
    on<ToggleViewType>(_onToggleViewType);
  }

  void _onToggleViewType(ToggleViewType event, Emitter<ViewTypeState> emit) {
    emit(
      state.copyWith(viewType: state.isGrid ? ViewType.list : ViewType.grid),
    );
  }
}
