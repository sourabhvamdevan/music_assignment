import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/grouping_engine.dart';
import '../bloc/library_bloc.dart';
import '../bloc/library_event.dart';
import '../bloc/library_state.dart';
import 'widgets/sticky_header.dart';
import '../../details/view/details_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels >
          _controller.position.maxScrollExtent - 300) {
        context.read<LibraryBloc>().add(FetchNextPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is LibraryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LibraryNoInternet) {
            return const Center(child: Text("NO INTERNET CONNECTION"));
          }

          if (state is LibraryLoaded) {
            final items = state.items;

            return CustomScrollView(
              controller: _controller,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Music Library",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      onChanged: (v) =>
                          context.read<LibraryBloc>().add(SearchChanged(v)),
                      decoration: InputDecoration(
                        hintText: "Search tracks...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                ..._buildSlivers(items),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  List<Widget> _buildSlivers(List<dynamic> items) {
    final List<Widget> slivers = [];

    String? currentHeader;
    List<TrackItem> currentTracks = [];

    for (final item in items) {
      if (item is HeaderItem) {
        if (currentHeader != null && currentTracks.isNotEmpty) {
          slivers.add(_buildTrackList(currentTracks));
          currentTracks = [];
        }

        currentHeader = item.letter;

        slivers.add(
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyHeaderDelegate(currentHeader),
          ),
        );
      } else if (item is TrackItem) {
        currentTracks.add(item);
      }
    }

    if (currentTracks.isNotEmpty) {
      slivers.add(_buildTrackList(currentTracks));
    }

    return slivers;
  }

  Widget _buildTrackList(List<TrackItem> tracks) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final track = tracks[index].track;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              track.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(track.artist),
            trailing: Text(track.id.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsScreen(trackId: track.id),
                ),
              );
            },
          ),
        );
      }, childCount: tracks.length),
    );
  }
}
