import 'package:flutter/material.dart';
import 'package:melofy/widgets/common_list_item.dart';
import 'package:melofy/widgets/mini_player.dart';
import '../db_functions/db_crud_functions.dart';
import '../db_functions/music_model.dart';
import '../utilities/snackbar_message.dart';
import '../widgets/delete_confirmation.dart';
import '../widgets/screen_navigators.dart';
import '../widgets/search.dart';
import 'now_playing_screen.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<MusicModel> _favoriteSongs = [];
  List<MusicModel> _filteredFavorites = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  void fetchSongs() {
    setState(() {
      _favoriteSongs = HiveDatabase.getAllMusic('favoritesBox');
      _filteredFavorites = _favoriteSongs..reversed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Column(
          children: [
            Search(
              hintValue: 'Search Music',
              onSearch: _filterFavorites,
            ),
            const ScreenNavigators(screenName: 'Favorites'),
            Expanded(
                child: _filteredFavorites.isNotEmpty
                    ? ListView.builder(
                        itemCount: _filteredFavorites.length,
                        itemBuilder: (context, index) {
                          final song = _filteredFavorites[index];
                          return CommonListItem(
                            song: song,
                            onButtonPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => DeleteConfirmationDialog(
                                  title: "Delete from Favorites",
                                  content: "Are you sure you want to delete ?",
                                  onConfirm: () {
                                    HiveDatabase.deleteMusic(
                                        'favoritesBox', song.id);
                                    SnackbarMessage.showSnackbar(
                                        context, 'Song removed from favorites');
                                    setState(() {
                                      _favoriteSongs.removeWhere(
                                          (item) => item.id == song.id);
                                      _filteredFavorites.removeWhere(
                                          (item) => item.id == song.id);
                                    });
                                  },
                                ),
                              );
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NowPlayingScreen(
                                    songs: _favoriteSongs,
                                    currentIndex: index,
                                  ),
                                ),
                              );
                            },
                            screenType: ScreenType.favorites,
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No Favorite Songs',
                          style: TextStyle(
                              color: Colors.grey, fontFamily: 'melofy-font'),
                        ),
                      )),
          ],
        ),
        bottomNavigationBar: MiniPlayer(),
      ),
    );
  }

  void _filterFavorites(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFavorites = _favoriteSongs;
      } else {
        _filteredFavorites = _favoriteSongs
            .where((song) =>
                song.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
