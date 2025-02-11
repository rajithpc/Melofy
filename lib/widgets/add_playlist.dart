import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../db_functions/song_model.dart';

class AddPlaylist extends StatefulWidget {
  final VoidCallback onClose; // Callback to close the widget

  const AddPlaylist({super.key, required this.onClose});

  @override
  _AddPlaylistState createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<AddPlaylist> {
  final TextEditingController _playlistController = TextEditingController();

  void _createPlaylist() {
    String playlistName = _playlistController.text.trim();

    if (playlistName.isEmpty) {
      return; // Don't create an empty playlist
    }

    var playlistBox = Hive.box<MyPlaylistModel>('playlists');

    // Check if the playlist already exists
    if (!playlistBox.containsKey(playlistName)) {
      playlistBox.put(
          playlistName, MyPlaylistModel(name: playlistName, songPaths: []));
    }

    widget.onClose(); // Close the AddPlaylist widget
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Playlist",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _playlistController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter playlist name",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: widget.onClose, // Close AddPlaylist on cancel
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: _createPlaylist,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
