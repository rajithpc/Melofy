import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:melofy/screens/all_songs.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'db_functions/song_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(FavoriteSongAdapter());
  Hive.registerAdapter(RecentSongsAdapter());
  Hive.registerAdapter(MyPlaylistModelAdapter());

  await Hive.openBox<FavoriteSong>('favorites');
  await Hive.openBox<RecentSongs>('Recents');
  await Hive.openBox<MyPlaylistModel>('Playlists');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
      MaterialApp(debugShowCheckedModeBanner: false, home: AllSongsScreen()));
}
