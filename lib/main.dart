import 'package:flutter/material.dart';
import 'package:melofy/screens/all_songs.dart';
import 'db_functions/db_crud_functions.dart';
import 'services/fetch_song_all_songs_from_internal_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.initHive();
  await fetchAndStoreSongs();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllSongsScreen(),
    ),
  );
}
