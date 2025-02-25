import 'package:flutter/material.dart';
import 'package:melofy/screens/select_playlist.dart';
import '../db_functions/db_crud_functions.dart';
import '../db_functions/music_model.dart';

class AddToDb extends StatelessWidget {
  const AddToDb({required this.song, required this.onClose, Key? key})
      : super(key: key);
  final MusicModel song;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        height: 100,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectPlaylistScreen(song: song),
                    ),
                  );
                  onClose();
                },
                child: const Text(
                  'Add to Playlist',
                  style: TextStyle(
                      fontFamily: 'melofy-font',
                      color: Colors.grey,
                      fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Divider(
                  height: 0.2,
                  color: Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  HiveDatabase.addMusic('favoritesBox', song);
                  onClose();
                },
                child: const Text(
                  'Add to Favorite',
                  style: TextStyle(
                      fontFamily: 'melofy-font',
                      color: Colors.grey,
                      fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
