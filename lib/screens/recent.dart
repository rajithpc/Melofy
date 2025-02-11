import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:melofy/db_functions/song_model.dart';
import 'package:melofy/widgets/search.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../widgets/bottom_play.dart';
import '../widgets/screen_navigators.dart';

class Recent extends StatefulWidget {
  const Recent({super.key});

  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  List<RecentSongs> _recentSongs = [];
  List<RecentSongs> _filteredRecentSongs = [];

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
              child: ValueListenableBuilder(
                valueListenable: Hive.box<RecentSongs>('Recents').listenable(),
                builder: (context, Box<RecentSongs> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text(
                        'No recents added.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  _recentSongs = box.values.toList().cast<RecentSongs>();
                  if (_filteredRecentSongs.isEmpty ||
                      _filteredRecentSongs.length > _recentSongs.length) {
                    _filteredRecentSongs = _recentSongs;
                  }

                  return ListView.builder(
                    itemCount: _filteredRecentSongs.length,
                    itemBuilder: (context, index) {
                      final song = _filteredRecentSongs[index];
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
                              child: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
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
