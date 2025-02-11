import 'package:hive/hive.dart';
import 'song_model.dart';

Future<void> addToFavorites(FavoriteSong song) async {
  final box = Hive.box<FavoriteSong>('favorites');
  if (!box.values.any((element) => element.id == song.id)) {
    await box.add(song);
  }
}

Future<void> removeFromFavorites(int songId) async {
  final box = Hive.box<FavoriteSong>('favorites');
  final key = box.keys
      .firstWhere((key) => box.get(key)?.id == songId, orElse: () => null);
  if (key != null) {
    await box.delete(key);
  }
}

Future<void> addToRecents(RecentSongs song) async {
  final box = Hive.box<RecentSongs>('Recents');
  if (!box.values.any((element) => element.id == song.id)) {
    await box.add(song);
  }
}

Future<void> removeFromRecents(int songId) async {
  final box = Hive.box<RecentSongs>('Recents');
  final key = box.keys
      .firstWhere((key) => box.get(key)?.id == songId, orElse: () => null);
  if (key != null) {
    await box.delete(key);
  }
}

void createPlaylist(String playlistName) {
  var playlistBox = Hive.box<MyPlaylistModel>('playlists');
  playlistBox.put(
      playlistName, MyPlaylistModel(name: playlistName, songPaths: []));
}

void deletePlaylist(String playlistName) {
  var playlistBox = Hive.box<MyPlaylistModel>('playlists');
  playlistBox.delete(playlistName);
}

void addSongToPlaylist(String playlistName, String songPath) {
  var playlistBox = Hive.box<MyPlaylistModel>('playlists');
  MyPlaylistModel? playlist = playlistBox.get(playlistName);

  if (playlist != null) {
    playlist.songPaths.add(songPath);
    playlist.save();
  }
}

void removeSongFromPlaylist(String playlistName, String songPath) {
  var playlistBox = Hive.box<MyPlaylistModel>('playlists');
  MyPlaylistModel? playlist = playlistBox.get(playlistName);

  if (playlist != null) {
    playlist.songPaths.remove(songPath);
    playlist.save();
  }
}
