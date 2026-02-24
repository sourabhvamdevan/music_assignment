import '../../features/library/models/track_model.dart';

abstract class GroupedItem {}

class HeaderItem extends GroupedItem {
  final String letter;
  HeaderItem(this.letter);
}

class TrackItem extends GroupedItem {
  final TrackModel track;
  TrackItem(this.track);
}

List<GroupedItem> groupTracks(List<TrackModel> tracks) {
  final Map<String, List<TrackModel>> grouped = {};

  for (final t in tracks) {
    final key = t.title[0].toUpperCase();
    grouped.putIfAbsent(key, () => []).add(t);
  }

  final keys = grouped.keys.toList()..sort();
  final List<GroupedItem> result = [];

  for (final k in keys) {
    result.add(HeaderItem(k));
    for (final t in grouped[k]!) {
      result.add(TrackItem(t));
    }
  }

  return result;
}
