import 'package:flutter/material.dart';
import 'package:melofy/db_functions/music_model.dart';
import 'package:melofy/screens/now_playing_screen.dart';
import 'package:melofy/screens/playlist.dart';
import 'package:melofy/widgets/common_list_item.dart';
import '../db_functions/db_crud_functions.dart';
import '../widgets/delete_confirmation.dart';
import '../widgets/search.dart';
import 'select_songs_screen.dart';

class PlaylistSongsScreen extends StatefulWidget {
  const PlaylistSongsScreen({super.key, required this.playlist});
  final MyPlaylistModel playlist;

  @override
  _PlaylistSongsScreenState createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  List<MusicModel> _songs = [];
  List<MusicModel> _filteredSongs = [];

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  void fetchSongs() {
    setState(() {
      _songs = HiveDatabase.getAllMusicFromPlaylist(widget.playlist.playlistId);
      _filteredSongs = List.from(_songs.reversed);
    });
  }

  void _filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSongs = List.from(_songs);
      } else {
        _filteredSongs = _songs.where((song) {
          final title = song.title.toLowerCase();
          final artist = song.artist?.toLowerCase() ?? '';
          return title.contains(query.toLowerCase()) ||
              artist.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.grey,
        title: Text(widget.playlist.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              List<MusicModel> selectedSongs = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelectSongsScreen(playlist: widget.playlist),
                ),
              );

              if (selectedSongs.isNotEmpty) {
                HiveDatabase.removeMultipleSongsFromPlaylist(
                    widget.playlist.playlistId, widget.playlist.songs);
                HiveDatabase.addMultipleSongsToPlaylist(
                    widget.playlist.playlistId, selectedSongs);
                setState(() {
                  fetchSongs();
                });
              }
            },
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Playlist(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Search(
            hintValue: 'Search Music',
            onSearch: _filterSongs,
          ),
          Expanded(
            child: _filteredSongs.isEmpty
                ? const Center(
                    child: Text(
                      "No Songs Found",
                      style: TextStyle(
                          color: Colors.grey, fontFamily: "Melofy-font"),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = _filteredSongs[index];

                      return CommonListItem(
                          song: song,
                          onButtonPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => DeleteConfirmationDialog(
                                title: "Delete Playlist",
                                content: "Are you sure you want to delete ?",
                                onConfirm: () {
                                  HiveDatabase.removeMusicFromPlaylist(
                                      widget.playlist.playlistId, song);
                                  setState(() {
                                    _songs.removeWhere(
                                        (item) => item.id == song.id);
                                    _filteredSongs.removeWhere(
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
                                  songs: _songs,
                                  currentIndex: index,
                                ),
                              ),
                            );
                          },
                          screenType: ScreenType.playlistSongs);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
