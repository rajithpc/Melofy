import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db_functions/song_model.dart';
import '../widgets/bottom_play.dart';
import '../widgets/screen_navigators.dart';
import '../widgets/search.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<FavoriteSong> _favoriteSongs = [];
  List<FavoriteSong> _filteredFavorites = [];

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
              child: ValueListenableBuilder(
                valueListenable:
                    Hive.box<FavoriteSong>('favorites').listenable(),
                builder: (context, Box<FavoriteSong> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text(
                        'No favorites added.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  // Initialize favorite songs list
                  _favoriteSongs = box.values.toList().cast<FavoriteSong>();
                  if (_filteredFavorites.isEmpty) {
                    _filteredFavorites = _favoriteSongs;
                  }

                  return ListView.builder(
                    itemCount: _filteredFavorites.length,
                    itemBuilder: (context, index) {
                      final song = _filteredFavorites[index];
                      final songName = song.title.split('|').first.trim();
                      final artistName = song.artist.split(',').first.trim();
                      return Column(
                        children: [
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: QueryArtworkWidget(
                                id: song.id,
                                type: ArtworkType.AUDIO,
                                artworkBorder: BorderRadius.zero,
                                artworkFit: BoxFit.cover,
                                nullArtworkWidget: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.music_note,
                                    size: 30,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              songName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'melofy-font',
                              ),
                            ),
                            subtitle: Text(
                              artistName,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'melofy-font',
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                box.deleteAt(index);
                              },
                              child: Image.asset(
                                'assets/images/favorites.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(70, 0, 20, 0),
                            child: Divider(
                              thickness: 0.2,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomPlay(),
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
