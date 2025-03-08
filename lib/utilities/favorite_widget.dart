import 'package:flutter/material.dart';
import 'package:melofy/db_functions/music_model.dart';

import '../db_functions/db_crud_functions.dart';
import 'snackbar_message.dart';

class FavoriteWidget extends StatefulWidget {
  final MusicModel song;
  const FavoriteWidget({required this.song, super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  List<MusicModel> favoriteSongs = [];

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  void getFavorites() {
    favoriteSongs = HiveDatabase.getAllMusic('favoritesBox');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: favoriteSongs.any((favSong) => favSong.id == widget.song.id)
          ? IconButton(
              onPressed: () {
                HiveDatabase.deleteMusic('favoritesBox', widget.song.id);
                setState(() {
                  getFavorites();
                });
                SnackbarMessage.showSnackbar(
                    context, 'song removed from favorites');
              },
              icon: const Icon(Icons.favorite),
              color: Colors.white,
            )
          : IconButton(
              onPressed: () {
                HiveDatabase.addMusic('favoritesBox', widget.song);
                setState(() {
                  getFavorites();
                });
                SnackbarMessage.showSnackbar(
                    context, 'song added to favorites');
              },
              icon: const Icon(Icons.favorite_border),
              color: Colors.white),
    );
  }
}
