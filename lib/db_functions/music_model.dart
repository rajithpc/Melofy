import 'package:hive/hive.dart';
part 'music_model.g.dart';

@HiveType(typeId: 0)
class MusicModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? artist;

  @HiveField(3)
  final String path;

  @HiveField(4)
  final int playCount;

  @HiveField(5)
  final String? data;

  @HiveField(6)
  final String? album;

  @HiveField(7)
  final int recentNo;

  @HiveField(8)
  final int favoriteNo;

  MusicModel(
      {required this.id,
      required this.title,
      required this.artist,
      required this.path,
      required this.playCount,
      required this.data,
      required this.album,
      required this.recentNo,
      required this.favoriteNo});
}

@HiveType(typeId: 1)
class MyPlaylistModel {
  @HiveField(0)
  final int playlistId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<MusicModel> songs;

  MyPlaylistModel({
    required this.playlistId,
    required this.name,
    required this.songs,
  });
}
