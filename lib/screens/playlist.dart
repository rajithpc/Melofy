import 'package:flutter/material.dart';
import 'package:melofy/widgets/playlist_item.dart';
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
            _filteredPlaylists.isNotEmpty
                ? Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        children:
                            List.generate(_filteredPlaylists.length, (index) {
                          return PlaylistItem(
                              playlistName: _filteredPlaylists[index].name,
                              songCount: _filteredPlaylists[index].songs.length,
                              artworkId:
                                  _filteredPlaylists[index].songs.isNotEmpty
                                      ? _filteredPlaylists[index].songs[0].id
                                      : 0,
                              onEdit: () {},
                              onDelete: () {});
                        })),
                  )
                : const Center(
                    child: Text(
                      'No Playlist Found',
                      style: TextStyle(
                          color: Colors.grey, fontFamily: 'melofy-font'),
                    ),
                  ),
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
