import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/details_repository.dart';

abstract class DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final Map<String, dynamic> track;
  final String lyrics;

  DetailsLoaded(this.track, this.lyrics);
}

class DetailsError extends DetailsState {
  final String message;
  DetailsError(this.message);
}

class DetailsNoInternet extends DetailsState {}

class DetailsBloc extends Cubit<DetailsState> {
  final DetailsRepository repository;

  DetailsBloc(this.repository) : super(DetailsLoading());

  Future<void> fetch(int trackId) async {
    emit(DetailsLoading());

    try {
      final track = await repository.fetchDetails(trackId);

      final lyrics = await repository.fetchLyrics(
        track['trackName'] ?? '',
        track['artistName'] ?? '',
      );

      emit(DetailsLoaded(track, lyrics));
    } on SocketException {
      emit(DetailsNoInternet());
    } catch (e) {
      emit(DetailsError(e.toString()));
    }
  }
}
