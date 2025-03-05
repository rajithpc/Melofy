import 'package:flutter/material.dart';
import 'package:melofy/utilities/snackbar_message.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db_functions/db_crud_functions.dart';
import '../db_functions/music_model.dart';
import '../screens/select_playlist.dart';

class BottomSheetAddToDB extends StatefulWidget {
  final MusicModel song;
  const BottomSheetAddToDB({required this.song, super.key});

  @override
  State<BottomSheetAddToDB> createState() => _BottomSheetAddToDBState();
}

class _BottomSheetAddToDBState extends State<BottomSheetAddToDB> {
  List<MusicModel> favoriteSongs = [];

  void getFavorites() {
    favoriteSongs = HiveDatabase.getAllMusic('favoritesBox');
  }

  @override
  Widget build(BuildContext context) {
    List<MusicModel> favoriteSongs = HiveDatabase.getAllMusic('favoritesBox');

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      child: const Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: 200,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: QueryArtworkWidget(
                            id: widget.song.id,
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
                          widget.song.title.length > 30
                              ? '${widget.song.title.substring(0, 30)}...'
                              : widget.song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'melofy-font',
                          ),
                        ),
                        subtitle: Text(
                          widget.song.artist!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'melofy-font',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => SelectPlaylistScreen(
                                  song: widget.song,
                                  onClose: () => Navigator.pop(context)),
                            ),
                          );
                          setState(() {
                            getFavorites();
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_card_sharp,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 20),
                              Text(
                                'Add to Playlist',
                                style: TextStyle(
                                    fontFamily: 'melofy-font',
                                    color: Colors.grey,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Divider(
                          height: 0.2,
                          color: Colors.grey,
                        ),
                      ),
                      favoriteSongs
                              .any((favSong) => favSong.id == widget.song.id)
                          ? GestureDetector(
                              onTap: () {
                                HiveDatabase.deleteMusic(
                                    'favoritesBox', widget.song.id);
                                SnackbarMessage.showSnackbar(
                                    context, 'song removed from favorites');
                                Navigator.pop(context);
                                setState(() {
                                  getFavorites();
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Icon(Icons.remove_circle_outline,
                                        color: Colors.grey),
                                    SizedBox(width: 20),
                                    Text(
                                      'Remove from favorites',
                                      style: TextStyle(
                                          fontFamily: 'melofy-font',
                                          color: Colors.grey,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                HiveDatabase.addMusic(
                                    'favoritesBox', widget.song);
                                SnackbarMessage.showSnackbar(
                                    context, 'song added to favorites');
                                Navigator.pop(context);
                                setState(() {
                                  getFavorites();
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Icon(Icons.add_circle_outline,
                                        color: Colors.grey),
                                    SizedBox(width: 20),
                                    Text(
                                      'Add to favorite',
                                      style: TextStyle(
                                          fontFamily: 'melofy-font',
                                          color: Colors.grey,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
