// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteSongAdapter extends TypeAdapter<FavoriteSong> {
  @override
  final int typeId = 1;

  @override
  FavoriteSong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteSong(
      id: fields[0] as int,
      title: fields[1] as String,
      artist: fields[2] as String,
      duration: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteSong obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteSongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecentSongsAdapter extends TypeAdapter<RecentSongs> {
  @override
  final int typeId = 2;

  @override
  RecentSongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentSongs(
      id: fields[0] as int,
      title: fields[1] as String,
      artist: fields[2] as String,
      duration: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecentSongs obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MyPlaylistModelAdapter extends TypeAdapter<MyPlaylistModel> {
  @override
  final int typeId = 3;

  @override
  MyPlaylistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyPlaylistModel(
      name: fields[0] as String,
      songPaths: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MyPlaylistModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.songPaths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyPlaylistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
