import 'package:flutter/material.dart';
import 'package:melofy/db_functions/music_model.dart';
import 'package:melofy/widgets/add_playlist.dart';
import '../db_functions/db_crud_functions.dart';
import '../widgets/snackbar_message.dart';
import '../widgets/search.dart';

class SelectPlaylistScreen extends StatefulWidget {
  const SelectPlaylistScreen(
      {required this.song, required this.onClose, super.key});

  final MusicModel song;
  final VoidCallback onClose;

  @override
  State<SelectPlaylistScreen> createState() => _SelectPlaylistScreenState();
}

class _SelectPlaylistScreenState extends State<SelectPlaylistScreen> {
  List<MyPlaylistModel> playlists = [];
  List<MyPlaylistModel> _filteredPlaylists = [];
  bool addToPlaylistEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchPlaylists();
  }

  void _fetchPlaylists() {
    setState(() {
      playlists = HiveDatabase.getAllPlaylists();
      _filteredPlaylists = playlists.reversed.toList();
    });
  }

  void _addSongToPlaylist(int playlistId) {
    HiveDatabase.addMusicToPlaylist(playlistId, widget.song);
    SnackbarMessage.showSnackbar(context, 'Song added to playlist');
    _fetchPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.grey,
          title: const Text(
            'Select Playlist',
            style: TextStyle(fontFamily: 'melofy-font'),
          ),
        ),
        body: Column(
          children: [
            Search(
              hintValue: 'Search Playlist',
              onSearch: _filterPlaylists,
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
                            onTap: () {
                              _addSongToPlaylist(
                                  _filteredPlaylists[index].playlistId);
                              Navigator.pop(context);
                              widget.onClose;
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
        bottomNavigationBar: addToPlaylistEnabled
            ? AddPlaylist(
                playlist: null,
                onClose: () {
                  addToPlaylistEnabled = false;
                  _fetchPlaylists();
                  _filterPlaylists;
                })
            : IconButton(
                onPressed: () {
                  setState(() {
                    addToPlaylistEnabled = true;
                  });
                },
                icon: const Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.grey,
                )),
      ),
    );
  }

  void _filterPlaylists(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPlaylists = playlists;
      } else {
        _filteredPlaylists = playlists
            .where((playlist) =>
                playlist.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}
