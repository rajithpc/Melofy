import 'package:flutter/material.dart';
import 'package:melofy/widgets/snackbar_message.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db_functions/db_crud_functions.dart';
import '../db_functions/music_model.dart';
import '../screens/favorites.dart';
import '../screens/select_playlist.dart';
import 'common_list_item.dart';
import 'favorite_widget.dart';

class BottomSheetWidget extends StatefulWidget {
  final MusicModel song;
  final ScreenType screenType;
  final VoidCallback onButtonPressed;

  const BottomSheetWidget(
      {required this.song,
      required this.screenType,
      required this.onButtonPressed,
      super.key});

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  List<MusicModel> favoriteSongs = [];

  void getFavorites() {
    favoriteSongs = HiveDatabase.getAllFavorites();
  }

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      onTap: () {
        getFavorites();
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => SelectPlaylistScreen(
                                  song: widget.song,
                                  onClose: () => setState(() {})),
                            ),
                          );
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
                      ////////////////////////////////////////////////////////
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Divider(
                          height: 10,
                          color: Colors.grey,
                        ),
                      ),
                      //////////////////////////////////////////////////////
                      favoriteSongs
                              .any((favSong) => favSong.id == widget.song.id)
                          ? GestureDetector(
                              onTap: () {
                                HiveDatabase.deleteMusic(
                                    'favoritesBox', widget.song.id);
                                SnackbarMessage.showSnackbar(
                                    context, 'Song removed from favorites');
                                Navigator.pop(context);
                                setState(() {
                                  getFavorites();
                                  FavoriteWidget.refreshNotifier.value =
                                      !FavoriteWidget.refreshNotifier.value;
                                  Favorites.refreshNotifier.value =
                                      !Favorites.refreshNotifier.value;
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
                                HiveDatabase.addToFavorites(widget.song);
                                SnackbarMessage.showSnackbar(
                                    context, 'Song added to favorites');
                                Navigator.pop(context);
                                setState(() {
                                  getFavorites();
                                  FavoriteWidget.refreshNotifier.value =
                                      !FavoriteWidget.refreshNotifier.value;
                                  Favorites.refreshNotifier.value =
                                      !Favorites.refreshNotifier.value;
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

                      //////////////////////////////////////////////////////////////
                      widget.screenType.index == 1 ||
                              widget.screenType.index == 4
                          ? const Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Divider(
                                height: 10,
                                color: Colors.grey,
                              ),
                            )
                          : const SizedBox(),

                      /////////////////////////////////////////////////////////

                      widget.screenType.index == 1
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                widget.onButtonPressed();
                              },
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Icon(Icons.remove_circle_outline_rounded,
                                        color: Colors.grey),
                                    SizedBox(width: 20),
                                    Text(
                                      'Remove from recents',
                                      style: TextStyle(
                                          fontFamily: 'melofy-font',
                                          color: Colors.grey,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),

                      /////////////////////////////////////////////////////////

                      widget.screenType.index == 4
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                widget.onButtonPressed();
                              },
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Icon(Icons.remove_circle_outline_rounded,
                                        color: Colors.grey),
                                    SizedBox(width: 20),
                                    Text(
                                      'Remove from mostly played',
                                      style: TextStyle(
                                          fontFamily: 'melofy-font',
                                          color: Colors.grey,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
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
