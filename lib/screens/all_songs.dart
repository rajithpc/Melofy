import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melofy/db_functions/db_crud_functions.dart';
import 'package:melofy/screens/now_playing_screen.dart';
import 'package:melofy/widgets/add_to_db.dart';
import 'package:melofy/widgets/bottom_play.dart';
import 'package:melofy/widgets/common_list_item.dart';
import 'package:melofy/widgets/screen_navigators.dart';
import 'package:melofy/widgets/search.dart';
import '../db_functions/music_model.dart';
import '../utilities/shared_preference_helper.dart';

class AllSongsScreen extends StatefulWidget {
  @override
  _AllSongsScreenState createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  List<MusicModel> _songs = [];
  MusicModel? favSong;
  List<MusicModel> _filteredSongs = [];
  bool _isBottumPlay = true;
  final AudioPlayer audioPlayer = AudioPlayer();

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
                                    onButtonPressed: () {
                                      setState(() {
                                        favSong = song;
                                        _isBottumPlay = false;
                                      });
                                    },
                                    onTap: () {
                                      HiveDatabase.addMusic(
                                          'recentlyPlayedBox', song);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NowPlayingScreen(song: song)),
                                      );
                                      setState(() async {
                                        MusicIdStorage.saveMusicId(song.id);
                                      });
                                    },
                                    isFavorites: false);
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
          bottomNavigationBar: _isBottumPlay
              ? BottomPlay()
              : AddToDb(
                  song: favSong!,
                  onClose: () {
                    setState(() {
                      _isBottumPlay = true;
                    });
                  },
                )),
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
