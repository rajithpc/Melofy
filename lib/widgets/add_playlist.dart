import 'package:flutter/material.dart';
import 'package:melofy/db_functions/db_crud_functions.dart';
import 'package:melofy/db_functions/music_model.dart';

class AddPlaylist extends StatefulWidget {
  final VoidCallback onClose;
  final MyPlaylistModel? playlist;

  const AddPlaylist({super.key, required this.playlist, required this.onClose});

  @override
  AddPlaylistState createState() => AddPlaylistState();
}

class AddPlaylistState extends State<AddPlaylist> {
  final TextEditingController _playlistController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _createPlaylist() {
    if (_formKey.currentState!.validate()) {
      String playlistName = _playlistController.text.trim();
      HiveDatabase.addPlaylist(playlistName);
      widget.onClose();
    }
  }

  void _updatePlaylist() {
    if (_formKey.currentState!.validate()) {
      MyPlaylistModel tempPlaylist = MyPlaylistModel(
        name: _playlistController.text.trim(),
        playlistId: widget.playlist!.playlistId,
        songs: widget.playlist!.songs,
      );
      HiveDatabase.updatePlaylist(tempPlaylist);
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
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
                  TextFormField(
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a playlist name';
                      }
                      return null;
                    },
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
                        onPressed: widget.playlist == null
                            ? _createPlaylist
                            : _updatePlaylist,
                        child: widget.playlist == null
                            ? const Text("Add",
                                style: TextStyle(color: Colors.green))
                            : const Text("Update",
                                style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
