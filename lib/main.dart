import 'package:flutter/material.dart';
import 'package:melofy/screens/all_songs.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'db_functions/db_crud_functions.dart';
import 'services/fetch_song_all_songs_from_internal_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.initHive();
  await fetchAndStoreSongs();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllSongsScreen(),
    ),
  );
}
