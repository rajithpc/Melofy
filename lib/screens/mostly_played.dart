import 'package:flutter/material.dart';
import 'package:melofy/db_functions/music_model.dart';
import 'package:melofy/widgets/common_list_item.dart';
import 'package:melofy/widgets/search.dart';
import '../db_functions/db_crud_functions.dart';
import '../widgets/delete_confirmation.dart';
import '../widgets/mini_player.dart';
import '../widgets/screen_navigators.dart';
import 'now_playing_screen.dart';

class MostlyPlayed extends StatefulWidget {
  const MostlyPlayed({super.key});

  @override
  MostlyPlayedState createState() => MostlyPlayedState();
}

class MostlyPlayedState extends State<MostlyPlayed> {
  List<MusicModel> _mostlyPlayedSongs = [];
  List<MusicModel> _filteredMostlyPlayedSongs = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  void fetchSongs() {
    setState(() {
      _mostlyPlayedSongs = HiveDatabase.getMostlyPlayedSongs();
      _filteredMostlyPlayedSongs = _mostlyPlayedSongs;
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
              onSearch: _filterMostlyPlayedSongs,
            ),
            const ScreenNavigators(screenName: 'Mostly played songs'),
            Expanded(
                child: _filteredMostlyPlayedSongs.isNotEmpty
                    ? ListView.builder(
                        itemCount: _filteredMostlyPlayedSongs.length,
                        itemBuilder: (context, index) {
                          final song = _filteredMostlyPlayedSongs[index];
                          return CommonListItem(
                              song: song,
                              onButtonPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      DeleteConfirmationDialog(
                                    title: "Remove from mostly",
                                    content:
                                        "Are you sure you want to remove ?",
                                    onConfirm: () {
                                      HiveDatabase.removeFromMostlyPlayed(song);
                                      setState(() {
                                        _mostlyPlayedSongs.removeWhere(
                                            (item) => item.id == song.id);
                                        _filteredMostlyPlayedSongs.removeWhere(
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
                                      songs: _mostlyPlayedSongs,
                                      currentIndex:
                                          _mostlyPlayedSongs.indexOf(song),
                                    ),
                                  ),
                                );
                              },
                              screenType: ScreenType.mostlyPlayed);
                        },
                      )
                    : const Center(
                        child: Text(
                          'No Mostly Played Songs',
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

  void _filterMostlyPlayedSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMostlyPlayedSongs = _mostlyPlayedSongs;
      } else {
        _filteredMostlyPlayedSongs = _mostlyPlayedSongs
            .where((song) =>
                song.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
