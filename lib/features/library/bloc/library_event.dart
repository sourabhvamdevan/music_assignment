abstract class LibraryEvent {}

class FetchInitial extends LibraryEvent {}

class FetchNextPage extends LibraryEvent {}

class SearchChanged extends LibraryEvent {
  final String query;
  SearchChanged(this.query);
}
