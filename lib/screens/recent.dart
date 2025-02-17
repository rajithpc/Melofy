import 'package:flutter/material.dart';
import 'package:melofy/db_functions/song_model.dart';
import 'package:melofy/widgets/common_list_item.dart';
import 'package:melofy/widgets/search.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db_functions/db_crud_functions.dart';
import '../services/fetch_song_by_id.dart';
import '../widgets/bottom_play.dart';
import '../widgets/screen_navigators.dart';

class Recent extends StatefulWidget {
  const Recent({super.key});

  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  late Future<List<RecentSongs>> _recentSongsFuture;
  List<RecentSongs> _recentSongs = [];
  List<RecentSongs> _filteredRecentSongs = [];

  @override
  void initState() {
    super.initState();
    _fetchRecentSongs();
  }

  void _fetchRecentSongs() {
    _recentSongsFuture = getAllRecentSongs();
    _recentSongsFuture.then((songs) {
      setState(() {
        _recentSongs = songs;
        _filteredRecentSongs = songs;
      });
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
              onSearch: _filterRecentSongs,
            ),
            const ScreenNavigators(screenName: 'Recent'),
            Expanded(
              child: FutureBuilder<List<RecentSongs>>(
                future: _recentSongsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No recent songs found"));
                  }

                  return ListView.builder(
                    itemCount: _filteredRecentSongs.length,
                    itemBuilder: (context, index) {
                      final song = _filteredRecentSongs[index];
                      return FutureBuilder<SongModel>(
                        future: fetchSongById(song.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return ListTile(
                                title: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData) {
                            return const ListTile(
                                title: Text("Song not found"));
                          }

                          SongModel songData = snapshot.data!;
                          return CommonListItem(
                            song: songData,
                            onButtonPressed: () {
                              removeFromRecents(song.id);
                            },
                            isFavorites: false,
                          );
                        },
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

  void _filterRecentSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRecentSongs = _recentSongs;
      } else {
        _filteredRecentSongs = _recentSongs
            .where((song) =>
                song.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
