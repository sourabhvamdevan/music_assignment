import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'features/library/bloc/library_bloc.dart';
import 'features/library/bloc/library_event.dart';
import 'features/library/repository/library_repository.dart';
import 'features/library/view/library_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(http.Client());
    final repository = LibraryRepository(apiClient);

    return BlocProvider(
      create: (_) => LibraryBloc(repository)..add(FetchInitial()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LibraryScreen(),
      ),
    );
  }
}
