import 'package:flutter/material.dart';
import 'package:melofy/db_functions/db_crud_functions.dart';
import 'package:melofy/db_functions/music_model.dart';

class AddPlaylist extends StatefulWidget {
  final VoidCallback onClose;

  const AddPlaylist({super.key, required this.onClose});

  @override
  _AddPlaylistState createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<AddPlaylist> {
  final TextEditingController _playlistController = TextEditingController();

  void _createPlaylist() {
    String playlistName = _playlistController.text.trim();
    HiveDatabase.addPlaylist(playlistName);

    widget.onClose();
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
                      onPressed: widget.onClose,
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: _createPlaylist,
                      child: const Text("Add",
                          style: TextStyle(color: Colors.green)),
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
