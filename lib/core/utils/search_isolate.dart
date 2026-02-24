import '../../features/library/models/track_model.dart';

List<TrackModel> filterTracks(Map<String, dynamic> params) {
  final List<TrackModel> tracks = params['tracks'];
  final String query = params['query'].toLowerCase();

  return tracks.where((t) {
    return t.title.toLowerCase().contains(query) ||
        t.artist.toLowerCase().contains(query);
  }).toList();
}
