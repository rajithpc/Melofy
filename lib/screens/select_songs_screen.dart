import 'package:flutter/material.dart';
import 'package:melofy/db_functions/db_crud_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db_functions/music_model.dart';

class SelectSongsScreen extends StatefulWidget {
  final String playlistName;

  const SelectSongsScreen({super.key, required this.playlistName});

  @override
  _SelectSongsScreenState createState() => _SelectSongsScreenState();
}

class _SelectSongsScreenState extends State<SelectSongsScreen> {
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
            onPressed: () {
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
                bool isSelected = _selectedSongs.contains(song);

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
                          _selectedSongs.remove(song);
                        }
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedSongs.remove(song);
                      } else {
                        _selectedSongs.add(song);
                      }
                    });
                  },
                );
              },
            ),
    );
  }
}
