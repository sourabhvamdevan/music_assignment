// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;

// import '../../../core/network/api_client.dart';
// import '../bloc/details_bloc.dart';
// import '../repository/details_repository.dart';

// class DetailsScreen extends StatelessWidget {
//   final int trackId;

//   const DetailsScreen({super.key, required this.trackId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//           DetailsBloc(DetailsRepository(ApiClient(http.Client())))
//             ..fetch(trackId),
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Track Details")),
//         body: BlocBuilder<DetailsBloc, DetailsState>(
//           builder: (context, state) {
//             if (state is DetailsLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (state is DetailsNoInternet) {
//               return const Center(
//                 child: Text(
//                   "NO INTERNET CONNECTION",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               );
//             }

//             if (state is DetailsError) {
//               return Center(
//                 child: Text(
//                   state.message,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               );
//             }

//             if (state is DetailsLoaded) {
//               final track = state.track;
//               final lyrics = state.lyrics;

//               return Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         track['trackName'] ?? '',
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Artist: ${track['artistName'] ?? ''}",
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Album: ${track['collectionName'] ?? ''}",
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Duration: ${((track['trackTimeMillis'] ?? 0) ~/ 60000)} min",
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 16),
//                       const Divider(),
//                       const SizedBox(height: 12),
//                       const Text(
//                         "Lyrics",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(lyrics, style: const TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return const SizedBox();
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

import '../../../core/network/api_client.dart';
import '../bloc/details_bloc.dart';
import '../repository/details_repository.dart';

class DetailsScreen extends StatefulWidget {
  final int trackId;

  const DetailsScreen({super.key, required this.trackId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DetailsBloc(DetailsRepository(ApiClient(http.Client())))
            ..fetch(widget.trackId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Track Details")),
        body: BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            if (state is DetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DetailsNoInternet) {
              return const Center(child: Text("NO INTERNET CONNECTION"));
            }

            if (state is DetailsError) {
              return Center(child: Text(state.message));
            }

            if (state is DetailsLoaded) {
              final track = state.track;
              final lyrics = state.lyrics;

              final previewUrl = track['previewUrl'];

              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track['trackName'] ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Artist: ${track['artistName'] ?? ''}"),
                      const SizedBox(height: 8),
                      Text("Album: ${track['collectionName'] ?? ''}"),
                      const SizedBox(height: 16),

                      if (previewUrl != null)
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!isPlaying) {
                                await _player.play(UrlSource(previewUrl));
                              } else {
                                await _player.stop();
                              }

                              setState(() {
                                isPlaying = !isPlaying;
                              });
                            },
                            child: Text(
                              isPlaying ? "Stop Preview" : "Play Preview",
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),

                      const Text(
                        "Lyrics",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(lyrics),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
