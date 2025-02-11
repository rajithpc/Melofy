import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SelectSongsScreen extends StatefulWidget {
  final String playlistName;

  const SelectSongsScreen({super.key, required this.playlistName});

  @override
  _SelectSongsScreenState createState() => _SelectSongsScreenState();
}

class _SelectSongsScreenState extends State<SelectSongsScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _allSongs = [];
  List<String> _selectedSongs = [];

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    List<SongModel> fetchedSongs = await _audioQuery.querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

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
              child:
                  Text("No Songs Found", style: TextStyle(color: Colors.grey)),
            )
          : ListView.builder(
              itemCount: _allSongs.length,
              itemBuilder: (context, index) {
                final song = _allSongs[index];
                bool isSelected = _selectedSongs.contains(song.data);

                return ListTile(
                  leading: QueryArtworkWidget(
                    id: song.id,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(10),
                    nullArtworkWidget:
                        const Icon(Icons.music_note, color: Colors.grey),
                  ),
                  title: Text(song.title,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(song.artist ?? "Unknown Artist",
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSongs.add(song.data);
                        } else {
                          _selectedSongs.remove(song.data);
                        }
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedSongs.remove(song.data);
                      } else {
                        _selectedSongs.add(song.data);
                      }
                    });
                  },
                );
              },
            ),
    );
  }
}
