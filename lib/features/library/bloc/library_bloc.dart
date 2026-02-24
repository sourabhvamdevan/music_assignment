import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/query_constants.dart';
import '../../../core/utils/grouping_engine.dart';
import '../../../core/utils/search_isolate.dart';
import '../models/track_model.dart';
import '../repository/library_repository.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepository repository;

  final List<TrackModel> _master = [];
  final Set<int> _ids = {};

  int _index = 0;
  int _queryPointer = 0;
  bool _isFetching = false;
  bool _hasMore = true;

  LibraryBloc(this.repository) : super(LibraryLoading()) {
    on<FetchInitial>(_init);
    on<FetchNextPage>(_next);
    on<SearchChanged>(_search);
  }

  Future<void> _init(FetchInitial event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());

    _master.clear();
    _ids.clear();
    _index = 0;
    _queryPointer = 0;
    _hasMore = true;

    try {
      await _fetchPage();
      emit(LibraryLoaded(groupTracks(_master), _hasMore));
    } on SocketException {
      emit(LibraryNoInternet());
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  Future<void> _next(FetchNextPage event, Emitter<LibraryState> emit) async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;

    try {
      await _fetchPage();
      emit(LibraryLoaded(groupTracks(_master), _hasMore));
    } on SocketException {
      emit(LibraryNoInternet());
    } catch (e) {
      emit(LibraryError(e.toString()));
    }

    _isFetching = false;
  }

  Future<void> _fetchPage() async {
    if (_queryPointer >= kQueries.length) {
      _hasMore = false;
      return;
    }

    final tracks = await repository.fetchTracks(
      query: kQueries[_queryPointer],
      index: _index,
    );

    print("Query: ${kQueries[_queryPointer]} | Index: $_index");
    print("Fetched: ${tracks.length}");

    if (tracks.isEmpty) {
      _queryPointer++;
      _index = 0;

      if (_queryPointer >= kQueries.length) {
        _hasMore = false;
      }

      return;
    }

    for (final t in tracks) {
      if (!_ids.contains(t.id)) {
        _ids.add(t.id);
        _master.add(t);
      }
    }

    _index += 50;
  }

  Future<void> _search(SearchChanged event, Emitter<LibraryState> emit) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(LibraryLoaded(groupTracks(_master), _hasMore));
      return;
    }

    final filtered = await compute(filterTracks, {
      'tracks': _master,
      'query': query,
    });

    emit(LibraryLoaded(groupTracks(filtered), false));
  }
}
