import 'package:flutter/material.dart';
import 'package:melofy/db_functions/db_crud_functions.dart';
import 'package:melofy/screens/now_playing_screen.dart';
import 'package:melofy/widgets/common_list_item.dart';
import 'package:melofy/widgets/mini_player.dart';
import 'package:melofy/widgets/screen_navigators.dart';
import 'package:melofy/widgets/search.dart';
import '../db_functions/music_model.dart';

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({super.key});
  @override
  AllSongsScreenState createState() => AllSongsScreenState();
}

class AllSongsScreenState extends State<AllSongsScreen> {
  List<MusicModel> _songs = [];
  List<MusicModel> _filteredSongs = [];

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  void fetchSongs() {
    setState(() {
      _songs = HiveDatabase.getAllMusic('musicBox');
      _filteredSongs = _songs;
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
              onSearch: _filterSongs,
            ),
            const ScreenNavigators(screenName: 'All Songs'),
            Expanded(
                child: _songs.isNotEmpty
                    ? _filteredSongs.isNotEmpty
                        ? ListView.builder(
                            itemCount: _filteredSongs.length,
                            itemBuilder: (context, index) {
                              final song = _filteredSongs[index];
                              return CommonListItem(
                                song: song,
                                onButtonPressed: () {},
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NowPlayingScreen(
                                              songs: _songs,
                                              currentIndex:
                                                  _songs.indexOf(song),
                                            )),
                                  );
                                },
                                screenType: ScreenType.allSongs,
                              );
                            })
                        : const Center(
                            child: Text(
                              "No songs found",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          )
                    : const Center(child: Text("No audio files found")))
          ],
        ),
        bottomNavigationBar: const MiniPlayer(),
      ),
    );
  }

  void _filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSongs = _songs;
      } else {
        _filteredSongs = _songs
            .where((song) =>
                song.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
