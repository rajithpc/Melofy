import 'package:flutter/material.dart';
import 'package:melofy/screens/playlist_songs_screen.dart';
import 'package:melofy/widgets/delete_confirmation.dart';
import 'package:melofy/widgets/mini_player.dart';
import 'package:melofy/widgets/playlist_item.dart';
import '../db_functions/db_crud_functions.dart';
import '../widgets/screen_navigators.dart';
import '../widgets/search.dart';
import '../db_functions/music_model.dart';
import '../widgets/add_playlist.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  final TextEditingController _playlistController = TextEditingController();
  bool _isAddingPlaylist = false;
  List<MyPlaylistModel> _playlists = [];
  List<MyPlaylistModel> _filteredPlaylists = [];
  MyPlaylistModel? _selectedPlaylist;

  @override
  void initState() {
    super.initState();
    fetchPlaylist();
  }

  void fetchPlaylist() {
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
                ? AddPlaylist(
                    playlist: _selectedPlaylist,
                    onClose: () {
                      _toggleAddPlaylist;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Playlist()),
                      );
                    })
                : Search(
                    hintValue: 'Search Playlist',
                    onSearch: _filterPlaylists,
                  ),
            ScreenNavigators(
              screenName: 'Playlist',
              onAddPlaylistPressed: () {
                _selectedPlaylist = null;
                _toggleAddPlaylist();
              },
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlaylistSongsScreen(
                                          playlist: _filteredPlaylists[index])),
                                );
                              },
                              onEdit: () {
                                _selectedPlaylist = _filteredPlaylists[index];
                                _playlistController.text =
                                    _selectedPlaylist!.name;
                                _toggleAddPlaylist();
                              },
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      DeleteConfirmationDialog(
                                    title: "Delete Playlist",
                                    content:
                                        "Are you sure you want to delete ?",
                                    onConfirm: () {
                                      HiveDatabase.deletePlaylist(
                                          _filteredPlaylists[index].playlistId);
                                      setState(() {
                                        _playlists.removeWhere((item) =>
                                            item.playlistId ==
                                            _filteredPlaylists[index]
                                                .playlistId);
                                        _filteredPlaylists.removeWhere((item) =>
                                            item.playlistId ==
                                            _filteredPlaylists[index]
                                                .playlistId);
                                      });
                                    },
                                  ),
                                );
                              });
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
        bottomNavigationBar: MiniPlayer(),
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
