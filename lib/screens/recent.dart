import 'package:flutter/material.dart';
import 'package:melofy/db_functions/music_model.dart';
import 'package:melofy/widgets/common_list_item.dart';
import 'package:melofy/widgets/mini_player.dart';
import 'package:melofy/widgets/search.dart';
import '../db_functions/db_crud_functions.dart';
import '../widgets/delete_confirmation.dart';
import '../widgets/screen_navigators.dart';
import '../widgets/snackbar_message.dart';
import 'now_playing_screen.dart';

class Recent extends StatefulWidget {
  const Recent({super.key});

  @override
  RecentState createState() => RecentState();
}

class RecentState extends State<Recent> {
  List<MusicModel> _recentSongs = [];
  List<MusicModel> _filteredRecentSongs = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  void fetchSongs() {
    setState(() {
      _recentSongs = HiveDatabase.getAllRecents();
      _filteredRecentSongs = _recentSongs;
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
                child: _filteredRecentSongs.isNotEmpty
                    ? ListView.builder(
                        itemCount: _filteredRecentSongs.length,
                        itemBuilder: (context, index) {
                          final song = _filteredRecentSongs[index];
                          return CommonListItem(
                              song: song,
                              onButtonPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      DeleteConfirmationDialog(
                                    title: "Remove from recents",
                                    content:
                                        "Are you sure you want to remove ?",
                                    onConfirm: () {
                                      HiveDatabase.deleteMusic(
                                          'recentlyPlayedBox', song.id);
                                      SnackbarMessage.showSnackbar(
                                          context, 'Song removed from recents');
                                      setState(() {
                                        _recentSongs.removeWhere(
                                            (item) => item.id == song.id);
                                        _filteredRecentSongs.removeWhere(
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
                                      songs: _recentSongs,
                                      currentIndex: _recentSongs.indexOf(song),
                                    ),
                                  ),
                                );
                              },
                              screenType: ScreenType.recents);
                        },
                      )
                    : const Center(
                        child: Text(
                          'No Recently Played Songs',
                          style: TextStyle(
                              color: Colors.grey, fontFamily: 'melofy-font'),
                        ),
                      )),
          ],
        ),
        bottomNavigationBar: const MiniPlayer(),
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
