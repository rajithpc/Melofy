import 'package:flutter/material.dart';
import 'package:melofy/db_functions/db_crud_functions.dart';
import 'package:melofy/widgets/add_to_db.dart';
import 'package:melofy/widgets/bottom_play.dart';
import 'package:melofy/widgets/screen_navigators.dart';
import 'package:melofy/widgets/search.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import '../db_functions/song_model.dart';
import '../utilities/shared_preference_helper.dart';
import '../utilities/song_notifier.dart';
import 'now_playing_screen.dart';

class AllSongsScreen extends StatefulWidget {
  @override
  _AllSongsScreenState createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];
  List<SongModel> _filteredSongs = [];
  bool _permissionGranted = false;
  bool _isBottumPlay = true;
  FavoriteSong? favSong;
  RecentSongs? recentSong;

  @override
  void initState() {
    super.initState();
    _checkAndFetchSongs();
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _checkAndFetchSongs() async {
    _permissionGranted = await requestStoragePermission();
    if (_permissionGranted) {
      List<SongModel> songs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        ignoreCase: true,
        uriType: UriType.EXTERNAL,
      );

      print("Songs fetched: ${songs.length}");

      setState(() {
        _songs = songs;
        _filteredSongs = songs;
      });
    }
  }

  void _refreshSongList() async {
    List<SongModel> songs = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      ignoreCase: true,
      uriType: UriType.EXTERNAL,
    );

    setState(() {
      _songs = songs;
      _filteredSongs = songs;
    });
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
              const Column(
                children: [ScreenNavigators(screenName: 'All Songs')],
              ),
              Column(
                children: [
                  _permissionGranted
                      ? _songs.isNotEmpty
                          ? SizedBox(
                              height: 514,
                              child: _filteredSongs.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: _filteredSongs.length,
                                      itemBuilder: (context, index) {
                                        final song = _filteredSongs[index];
                                        final songName =
                                            song.title.split('|').first.trim();
                                        final artistName =
                                            song.artist == "<unknown>" ||
                                                    song.artist == null
                                                ? "Unknown Artist"
                                                : song.artist!
                                                    .split(',')
                                                    .first
                                                    .trim();
                                        return Column(
                                          children: [
                                            ListTile(
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: QueryArtworkWidget(
                                                  id: song.id,
                                                  type: ArtworkType.AUDIO,
                                                  artworkBorder:
                                                      BorderRadius.zero,
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
                                                    color: Colors.grey,
                                                    fontFamily: 'melofy-font'),
                                              ),
                                              subtitle: Text(
                                                artistName,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: 'melofy-font'),
                                              ),
                                              trailing: IconButton(
                                                  onPressed: () async {
                                                    final songData =
                                                        FavoriteSong(
                                                      id: song.id,
                                                      title: song.title,
                                                      artist: song.artist ??
                                                          "Unknown Artist",
                                                      duration:
                                                          song.duration ?? 0,
                                                    );
                                                    setState(() {
                                                      favSong = songData;
                                                      _isBottumPlay = false;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                    color: Colors.grey,
                                                  )),
                                              onTap: () async {
                                                recentSong = RecentSongs(
                                                  id: song.id,
                                                  title: song.title,
                                                  artist: song.artist ??
                                                      "Unknown Artist",
                                                  duration: song.duration ?? 0,
                                                );
                                                addToRecents(recentSong!);
                                                final songData = {
                                                  'id': song.id,
                                                  'title': song.title,
                                                  'artist': song.artist,
                                                  'duration': song.duration,
                                                };

                                                await SongPreferenceHelper
                                                    .saveSong(songData);
                                                SongNotifier.selectedSong
                                                    .value = songData;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        NowPlayingScreen(
                                                            song: song),
                                                  ),
                                                );
                                              },
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  70, 0, 20, 0),
                                              child: Divider(
                                                thickness: 0.2,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                  : const Center(
                                      child: Text(
                                        "No songs found",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                    ))
                          : const Center(child: Text("No audio files found"))
                      : const Center(child: Text("Permission not granted")),
                ],
              )
            ],
          ),
          bottomNavigationBar: _isBottumPlay
              ? const BottomPlay()
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
}
