import 'package:equatable/equatable.dart';

abstract class ViewTypeEvent extends Equatable {
  const ViewTypeEvent();

  @override
  List<Object?> get props => [];
}

class ToggleViewType extends ViewTypeEvent {}
