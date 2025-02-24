import 'package:flutter/material.dart';
import '../db_functions/db_crud_functions.dart';
import '../widgets/bottom_play.dart';
import '../widgets/screen_navigators.dart';
import '../widgets/search.dart';
import '../db_functions/music_model.dart';
import '../widgets/add_playlist.dart';
import 'playlist_songs_screen.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  bool _isAddingPlaylist = false;
  List<MyPlaylistModel> _playlists = [];
  List<MyPlaylistModel> _filteredPlaylists = [];

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  void fetchSongs() {
    setState(() {
      _playlists = HiveDatabase.getAllPlaylists();
      _filteredPlaylists = _playlists..reversed;
    });
  }

  void _toggleAddPlaylist() {
    setState(() {
      _isAddingPlaylist = !_isAddingPlaylist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Column(
          children: [
            _isAddingPlaylist
                ? AddPlaylist(onClose: () {
                    _toggleAddPlaylist;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Playlist()),
                    );
                  })
                : Search(
                    hintValue: 'Search Playlist',
                    onSearch: _filterPlaylists,
                  ),
            ScreenNavigators(
              screenName: 'Playlist',
              onAddPlaylistPressed: _toggleAddPlaylist,
            ),
            Expanded(
                child: _filteredPlaylists.isNotEmpty
                    ? ListView.builder(
                        itemCount: _filteredPlaylists.length,
                        itemBuilder: (context, index) {
                          MyPlaylistModel playlist = _filteredPlaylists[index];

                          return ListTile(
                            title: Text(
                              playlist.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              '${playlist.songs.length} songs',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                HiveDatabase.deletePlaylist(
                                    playlist.playlistId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Playlist(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlaylistSongsScreen(playlist: playlist),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No Playlist Found',
                          style: TextStyle(
                              color: Colors.grey, fontFamily: 'melofy-font'),
                        ),
                      )),
          ],
        ),
        bottomNavigationBar: BottomPlay(),
      ),
    );
  }

  void _filterPlaylists(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPlaylists = _playlists;
      } else {
        _filteredPlaylists = _playlists
            .where((playlist) =>
                playlist.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
