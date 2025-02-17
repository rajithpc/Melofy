import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db_functions/db_crud_functions.dart';
import '../db_functions/song_model.dart';
import '../widgets/search.dart';
import 'select_songs_screen.dart';

class PlaylistSongsScreen extends StatefulWidget {
  final MyPlaylistModel playlist;

  const PlaylistSongsScreen({super.key, required this.playlist});

  @override
  _PlaylistSongsScreenState createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];
  List<SongModel> _filteredSongs = [];

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    List<SongModel> allSongs = await _audioQuery.querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    List<SongModel> fetchedSongs = allSongs.where((song) {
      return widget.playlist.songPaths.contains(song.data);
    }).toList();

    setState(() {
      _songs = fetchedSongs;
      _filteredSongs = fetchedSongs;
    });
  }

  void _removeSongFromPlaylist(String songPath) {
    setState(() {
      removeSongFromPlaylist(widget.playlist.name, songPath);
      _songs.removeWhere((song) => song.data == songPath);
      _filteredSongs.removeWhere((song) => song.data == songPath);
    });
  }

  void _filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSongs = _songs;
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
              final selectedSongs = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelectSongsScreen(playlistName: widget.playlist.name),
                ),
              );

              if (selectedSongs != null && selectedSongs is List<String>) {
                for (String songPath in selectedSongs) {
                  addSongToPlaylist(widget.playlist.name, songPath);
                }
                _fetchSongs();
              }
            },
          ),
        ],
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
                                song.title.length > 24
                                    ? '${song.title.substring(0, 24)}...'
                                    : song.title,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(song.artist ?? "Unknown Artist",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey)),
                            trailing: IconButton(
                              onPressed: () {
                                _removeSongFromPlaylist(song.data);
                              },
                              icon:
                                  const Icon(Icons.delete, color: Colors.grey),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(70, 0, 20, 0),
                            child: Divider(thickness: 0.2, color: Colors.grey),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
