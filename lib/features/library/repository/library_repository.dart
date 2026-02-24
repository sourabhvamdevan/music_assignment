import '../../../core/network/api_client.dart';
import '../models/track_model.dart';

class LibraryRepository {
  final ApiClient apiClient;
  LibraryRepository(this.apiClient);

  Future<List<TrackModel>> fetchTracks({
    required String query,
    required int index,
  }) async {
    final url =
        "https://itunes.apple.com/search?term=$query&entity=song&limit=50&offset=$index";

    final data = await apiClient.get(url);

    if (data['results'] == null || data['results'].isEmpty) {
      return [];
    }

    final List results = data['results'];

    return results.map<TrackModel>((e) {
      return TrackModel(
        id: e['trackId'] ?? 0,
        title: e['trackName'] ?? "Unknown",
        artist: e['artistName'] ?? "Unknown",
        album: e['collectionName'] ?? "Unknown Album",
      );
    }).toList();
  }
}
