import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive/hive.dart';
import '../db_functions/music_model.dart';

Future<bool> requestPermission() async {
  var status = await Permission.storage.request();
  return status.isGranted;
}

Future<void> fetchAndStoreSongs() async {
  if (!await requestPermission()) return;

  final audioQuery = OnAudioQuery();
  List<SongModel> songs = await audioQuery.querySongs(
    sortType: SongSortType.TITLE,
    orderType: OrderType.ASC_OR_SMALLER,
    uriType: UriType.EXTERNAL,
  );

  final musicBox = Hive.box<MusicModel>('musicBox');

  for (var song in songs) {
    final music = MusicModel(
        id: song.id,
        title: song.title,
        artist: song.artist ?? "Unknown",
        path: song.data,
        playCount: 0,
        data: song.data,
        album: song.album);

    await musicBox.put(music.id, music);
  }
}
