import '../../../core/network/api_client.dart';

class DetailsRepository {
  final ApiClient apiClient;

  DetailsRepository(this.apiClient);

  Future<Map<String, dynamic>> fetchDetails(int trackId) async {
    final url = "https://itunes.apple.com/lookup?id=$trackId";

    final data = await apiClient.get(url);

    if (data['results'] == null || data['results'].isEmpty) {
      throw Exception("Track not found");
    }

    return data['results'][0];
  }

  Future<String> fetchLyrics(String title, String artist) async {
    final url =
        "https://lrclib.net/api/get?track_name=$title&artist_name=$artist";

    final data = await apiClient.get(url);

    if (data['plainLyrics'] != null) {
      return data['plainLyrics'];
    }

    return "No lyrics available.";
  }
}
