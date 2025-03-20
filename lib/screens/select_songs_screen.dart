import 'package:flutter/material.dart';
import 'package:melofy/db_functions/db_crud_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db_functions/music_model.dart';

class SelectSongsScreen extends StatefulWidget {
  final MyPlaylistModel playlist;

  const SelectSongsScreen({super.key, required this.playlist});

  @override
  SelectSongsScreenState createState() => SelectSongsScreenState();
}

class SelectSongsScreenState extends State<SelectSongsScreen> {
  List<MusicModel> _allSongs = [];
  List<MusicModel> _selectedSongs = [];

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    List<MusicModel> fetchedSongs = HiveDatabase.getAllMusic('musicBox');

    setState(() {
      _allSongs = fetchedSongs;
      _selectedSongs =
          HiveDatabase.getAllMusicFromPlaylist(widget.playlist.playlistId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Songs",
          style: TextStyle(fontFamily: "Melofy-font"),
        ),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final updatedPlaylist = MyPlaylistModel(
                playlistId: widget.playlist.playlistId,
                name: widget.playlist.name,
                songs: _selectedSongs,
              );
              await HiveDatabase.updatePlaylist(updatedPlaylist);
              Navigator.pop(context, _selectedSongs);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: _allSongs.isEmpty
          ? const Center(
              child: Text(
                "No Songs Found",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _allSongs.length,
              itemBuilder: (context, index) {
                final song = _allSongs[index];
                bool isSelected =
                    _selectedSongs.any((s) => s.id == song.id) ? true : false;

                return ListTile(
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
                    song.title.length > 25
                        ? '${song.title.substring(0, 25)}...'
                        : song.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    song.artist ?? "Unknown Artist",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSongs.add(song);
                        } else {
                          _selectedSongs.removeWhere((s) => s.id == song.id);
                        }
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedSongs.remove(song);
                      } else {
                        _selectedSongs.removeWhere((s) => s.id == song.id);
                      }
                    });
                  },
                );
              },
            ),
    );
  }
}
