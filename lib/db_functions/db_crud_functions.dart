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
///////////////////////////////////////////////////////////////////////////////

  static Future<void> addToRecents(MusicModel music) async {
    final box = Hive.box<MusicModel>(_recentlyPlayedBox);

    if (box.containsKey(music.id)) {
      await box.delete(music.id);
    }

    int generateUniqueId() {
      final recents = getAllMusic(_recentlyPlayedBox);
      return (recents.isNotEmpty
              ? recents
                  .map((recents) => recents.recentNo)
                  .reduce((a, b) => a > b ? a : b)
              : 0) +
          1;
    }

    MusicModel newRecentSong = MusicModel(
      id: music.id,
      title: music.title,
      artist: music.artist,
      path: music.path,
      data: music.data,
      album: music.album,
      playCount: music.playCount,
      favoriteNo: music.favoriteNo,
      recentNo: generateUniqueId(),
    );
    await box.put(newRecentSong.id, newRecentSong);
  }

  static List<MusicModel> getAllRecents() {
    final box = Hive.box<MusicModel>(_recentlyPlayedBox);
    List<MusicModel> recents = box.values.toList();
    recents.sort((a, b) => b.recentNo.compareTo(a.recentNo));
    return recents;
  }

///////////////////////////////////////////////////////////////////////////////

  static Future<void> addToFavorites(MusicModel music) async {
    final box = Hive.box<MusicModel>(_favoritesBox);

    if (box.containsKey(music.id)) {
      await box.delete(music.id);
    }

    int generateUniqueId() {
      final favorites = getAllMusic(_favoritesBox);
      return (favorites.isNotEmpty
              ? favorites
                  .map((favorites) => favorites.favoriteNo)
                  .reduce((a, b) => a > b ? a : b)
              : 0) +
          1;
    }

    MusicModel newFavoriteSong = MusicModel(
      id: music.id,
      title: music.title,
      artist: music.artist,
      path: music.path,
      data: music.data,
      album: music.album,
      playCount: music.playCount,
      recentNo: music.recentNo,
      favoriteNo: generateUniqueId(),
    );
    await box.put(newFavoriteSong.id, newFavoriteSong);
  }

  static List<MusicModel> getAllFavorites() {
    final box = Hive.box<MusicModel>(_favoritesBox);
    List<MusicModel> favorites = box.values.toList();
    favorites.sort((a, b) => b.favoriteNo.compareTo(a.favoriteNo));
    return favorites;
  }

////////////////////////////////////////////////////////////////////////////////

  static List<MusicModel> getMostlyPlayedSongs() {
    final box = Hive.box<MusicModel>(_musicBox);
    List<MusicModel> mostlyPlayed =
        box.values.where((song) => song.playCount > 0).toList();
    mostlyPlayed.sort((a, b) => b.playCount.compareTo(a.playCount));
    return mostlyPlayed.length >= 20
        ? mostlyPlayed.sublist(0, 20)
        : mostlyPlayed;
  }

  static Future<void> updatePlayCount(MusicModel music) async {
    final box = Hive.box<MusicModel>(_musicBox);
    MusicModel song = MusicModel(
        id: music.id,
        title: music.title,
        artist: music.artist,
        path: music.path,
        playCount: music.playCount + 1,
        data: music.data,
        album: music.album,
        recentNo: music.recentNo,
        favoriteNo: music.favoriteNo);
    await box.put(song.id, song);
  }

  static Future<void> removeFromMostlyPlayed(MusicModel music) async {
    final box = Hive.box<MusicModel>(_musicBox);
    MusicModel song = MusicModel(
        id: music.id,
        title: music.title,
        artist: music.artist,
        path: music.path,
        playCount: 0,
        data: music.data,
        album: music.album,
        recentNo: music.recentNo,
        favoriteNo: music.favoriteNo);
    await box.put(song.id, song);
  }
}
