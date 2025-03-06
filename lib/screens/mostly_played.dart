import 'package:flutter/material.dart';
import 'package:melofy/db_functions/music_model.dart';
import 'package:melofy/widgets/common_list_item.dart';
import 'package:melofy/widgets/search.dart';
import '../db_functions/db_crud_functions.dart';
import '../widgets/mini_player.dart';
import '../widgets/screen_navigators.dart';
import 'now_playing_screen.dart';

class MostlyPlayed extends StatefulWidget {
  const MostlyPlayed({super.key});

  @override
  _MostlyPlayedState createState() => _MostlyPlayedState();
}

class _MostlyPlayedState extends State<MostlyPlayed> {
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
      _mostlyPlayedSongs = HiveDatabase.getAllMusic('mostlyPlayedBox');
      _mostlyPlayedSongs.sort((a, b) => b.playCount.compareTo(a.playCount));
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
                              onButtonPressed: () {},
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NowPlayingScreen(
                                      songs: _mostlyPlayedSongs,
                                      currentIndex: index,
                                    ),
                                  ),
                                );
                              },
                              screenType: ScreenType.recents);
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
        bottomNavigationBar: MiniPlayer(),
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
