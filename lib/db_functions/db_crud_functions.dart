import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'music_model.dart';

class HiveDatabase {
  static const String _musicBox = 'musicBox';
  static const String _recentlyPlayedBox = 'recentlyPlayedBox';
  static const String _favoritesBox = 'favoritesBox';
  static const String _mostlyPlayedBox = 'mostlyPlayedBox';
  static const String _playlistsBox = 'playlistsBox';

  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(MusicModelAdapter());
    Hive.registerAdapter(MyPlaylistModelAdapter());
    await Hive.openBox<MusicModel>(_musicBox);
    await Hive.openBox<MusicModel>(_recentlyPlayedBox);
    await Hive.openBox<MusicModel>(_favoritesBox);
    await Hive.openBox<MusicModel>(_mostlyPlayedBox);
    await Hive.openBox<MyPlaylistModel>(_playlistsBox);
  }

  // static Future<void> addMusic(String boxName, MusicModel music) async {
  //   final box = Hive.box<MusicModel>(boxName);
  //   await box.put(music.id, music);
  // }

  static Future<void> addMusic(String boxName, MusicModel music) async {
    final box = Hive.box<MusicModel>(boxName);

    if (box.containsKey(music.id)) {
      await box.delete(music.id);
    }
    await box.put(music.id, music);
  }

  static List<MusicModel> getAllMusic(String boxName) {
    final box = Hive.box<MusicModel>(boxName);
    return box.values.toList();
  }

  static Future<void> updateMusic(String boxName, MusicModel music) async {
    final box = Hive.box<MusicModel>(boxName);
    await box.put(music.id, music);
  }

  static Future<void> deleteMusic(String boxName, int id) async {
    final box = Hive.box<MusicModel>(boxName);
    await box.delete(id);
  }

/*
  static Future<void> addPlaylist(MyPlaylistModel playlist) async {
    print('added');
    final box = Hive.box<MyPlaylistModel>(_playlistsBox);
    await box.put(playlist.playlistId, playlist);
    print('added');
  }

*/

  static Future<void> addPlaylist(String playlistName) async {
    final box = Hive.box<MyPlaylistModel>(_playlistsBox);

    bool alreadyExists =
        box.values.any((playlist) => playlist.name == playlistName);
    if (alreadyExists) return;

    int generateUniqueId() {
      final box = Hive.box<MyPlaylistModel>(_playlistsBox);
      return (box.keys.isNotEmpty
              ? box.keys.cast<int>().reduce((a, b) => a > b ? a : b)
              : 0) +
          1;
    }

    MyPlaylistModel newPlaylist = MyPlaylistModel(
      playlistId: generateUniqueId(),
      name: playlistName,
      songs: [],
    );

    await box.put(newPlaylist.playlistId, newPlaylist);
  }

  static List<MyPlaylistModel> getAllPlaylists() {
    final box = Hive.box<MyPlaylistModel>(_playlistsBox);
    return box.values.toList();
  }

  static Future<void> updatePlaylist(MyPlaylistModel playlist) async {
    final box = Hive.box<MyPlaylistModel>(_playlistsBox);
    if (box.containsKey(playlist.playlistId)) {
      await box.put(playlist.playlistId, playlist);
    }
  }

  static Future<void> deletePlaylist(int playlistId) async {
    final box = Hive.box<MyPlaylistModel>(_playlistsBox);
    if (box.containsKey(playlistId)) {
      await box.delete(playlistId);
    }
  }

  static MusicModel? getSongById(String boxName, int songId) {
    final box = Hive.box<MusicModel>(boxName);
    return box.get(songId);
  }

  static Future<void> addMusicToPlaylist(
      int playlistId, MusicModel songs) async {
    final box = Hive.box<MyPlaylistModel>(_playlistsBox);
    final playlist = box.get(playlistId);

    if (playlist != null) {
      final updatedSongs = List<MusicModel>.from(playlist.songs)..add(songs);
      final updatedPlaylist = MyPlaylistModel(
        playlistId: playlist.playlistId,
        name: playlist.name,
        songs: updatedSongs,
      );

      await box.put(playlistId, updatedPlaylist);
    }
  }

  static Future<void> removeMusicFromPlaylist(
      int playlistId, MusicModel songs) async {
    final box = Hive.box<MyPlaylistModel>(_playlistsBox);
    final playlist = box.get(playlistId);

    if (playlist != null) {
      final updatedSongs = List<MusicModel>.from(playlist.songs)..remove(songs);
      final updatedPlaylist = MyPlaylistModel(
        playlistId: playlist.playlistId,
        name: playlist.name,
        songs: updatedSongs,
      );

      await box.put(playlistId, updatedPlaylist);
    }
  }

  static Future<void> addMultipleSongsToPlaylist(
      int playlistId, List<MusicModel> songs) async {
    final box = Hive.box<MyPlaylistModel>(_playlistsBox);
    final playlist = box.get(playlistId);

    if (playlist != null) {
      final updatedSongs = Set<MusicModel>.from(playlist.songs)..addAll(songs);
      final updatedPlaylist = MyPlaylistModel(
        playlistId: playlist.playlistId,
        name: playlist.name,
        songs: updatedSongs.toList(),
      );

      await box.put(playlistId, updatedPlaylist);
    }
  }

  static Future<void> removeMultipleSongsFromPlaylist(
      int playlistId, List<MusicModel> songs) async {
    final box = Hive.box<MyPlaylistModel>(_playlistsBox);
    final playlist = box.get(playlistId);

    if (playlist != null) {
      final updatedSongs = List<MusicModel>.from(playlist.songs)
        ..removeWhere((id) => songs.contains(id));
      final updatedPlaylist = MyPlaylistModel(
        playlistId: playlist.playlistId,
        name: playlist.name,
        songs: updatedSongs,
      );

      await box.put(playlistId, updatedPlaylist);
    }
  }

  static List<MusicModel> getAllMusicFromPlaylist(int playlistId) {
    final playlistBox = Hive.box<MyPlaylistModel>(_playlistsBox);
    final playlist = playlistBox.get(playlistId);

    if (playlist == null) return [];

    return playlist.songs;
  }
}
