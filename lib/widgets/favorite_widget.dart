import 'package:flutter/material.dart';
import 'package:melofy/db_functions/music_model.dart';

import '../db_functions/db_crud_functions.dart';
import '../screens/favorites.dart';
import 'snackbar_message.dart';

class FavoriteWidget extends StatefulWidget {
  final MusicModel song;
  const FavoriteWidget({required this.song, super.key});

  static final ValueNotifier<bool> refreshNotifier = ValueNotifier<bool>(false);

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
    favoriteSongs = HiveDatabase.getAllFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: FavoriteWidget.refreshNotifier,
      builder: (context, _, __) {
        getFavorites();
        bool isFavorite =
            favoriteSongs.any((favSong) => favSong.id == widget.song.id);

        return IconButton(
          onPressed: () {
            if (isFavorite) {
              HiveDatabase.deleteMusic('favoritesBox', widget.song.id);
              SnackbarMessage.showSnackbar(
                  context, 'Song removed from favorites');
            } else {
              HiveDatabase.addToFavorites(widget.song);
              SnackbarMessage.showSnackbar(context, 'Song added to favorites');
            }

            FavoriteWidget.refreshNotifier.value =
                !FavoriteWidget.refreshNotifier.value;
            Favorites.refreshNotifier.value = !Favorites.refreshNotifier.value;
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
