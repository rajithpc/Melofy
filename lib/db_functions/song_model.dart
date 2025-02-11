import 'package:hive/hive.dart';

part 'song_model.g.dart';

@HiveType(typeId: 1)
class FavoriteSong {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final int duration;

  FavoriteSong(
      {required this.id,
      required this.title,
      required this.artist,
      required this.duration});
}

@HiveType(typeId: 2)
class RecentSongs {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final int duration;

  RecentSongs(
      {required this.id,
      required this.title,
      required this.artist,
      required this.duration});
}

@HiveType(typeId: 3)
class MyPlaylistModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> songPaths;

  MyPlaylistModel({required this.name, required this.songPaths});
}

@HiveType(typeId: 1)
class MostPlayed {
  @HiveField(4)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final int duration;

  @HiveField(3)
  final int playcount;

  MostPlayed(
      {required this.id,
      required this.title,
      required this.artist,
      required this.duration,
      required this.playcount});
}
