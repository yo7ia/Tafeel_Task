import 'package:equatable/equatable.dart';

enum ViewType { list, grid }

class ViewTypeState extends Equatable {
  final ViewType viewType;

  const ViewTypeState({this.viewType = ViewType.list});

  bool get isGrid => viewType == ViewType.grid;

  ViewTypeState copyWith({ViewType? viewType}) {
    return ViewTypeState(viewType: viewType ?? this.viewType);
  }

  @override
  List<Object?> get props => [viewType];
}
