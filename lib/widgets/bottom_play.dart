import 'package:flutter/material.dart';
import 'package:melofy/db_functions/db_crud_functions.dart';
import 'package:melofy/db_functions/music_model.dart';
import 'package:melofy/utilities/shared_preference_helper.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../screens/now_playing_screen.dart';

class BottomPlay extends StatelessWidget {
  BottomPlay({super.key});

  MusicModel? selectedMusic = HiveDatabase.getAllMusic('musicBox')[0];

  void initState() async {
    selectedMusic = await MusicIdStorage.getMusicModel();
  }

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
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NowPlayingScreen(song: selectedMusic!),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: QueryArtworkWidget(
                        id: selectedMusic!.id,
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
                      selectedMusic!.title,
                      style: const TextStyle(
                          color: Colors.grey, fontFamily: 'melofy-font'),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      selectedMusic!.artist!,
                      style: const TextStyle(
                          color: Colors.grey, fontFamily: 'melofy-font'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.grey,
                          size: 30,
                        ),
                        onPressed: () {
                          // Add play functionality here
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.play_circle_outline,
                          color: Colors.grey,
                          size: 40,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.grey,
                          size: 30,
                        ),
                        onPressed: () {
                          // Add play functionality here
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
