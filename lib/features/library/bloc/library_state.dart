import 'package:equatable/equatable.dart';
import '../../../core/utils/grouping_engine.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();
  @override
  List<Object?> get props => [];
}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<GroupedItem> items;
  final bool hasMore;

  const LibraryLoaded(this.items, this.hasMore);

  @override
  List<Object?> get props => [items, hasMore];
}

class LibraryNoInternet extends LibraryState {}

class LibraryError extends LibraryState {
  final String message;
  const LibraryError(this.message);

  @override
  List<Object?> get props => [message];
}
