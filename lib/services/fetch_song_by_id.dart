import 'package:on_audio_query/on_audio_query.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();

Future<SongModel> fetchSongById(int songId) async {
  List<SongModel> allSongs = await _audioQuery.querySongs();

  // Throw an exception if the song is not found
  SongModel song = allSongs.firstWhere(
    (song) => song.id == songId,
    orElse: () => throw Exception("Song with ID $songId not found"),
  );

  return song;
}
