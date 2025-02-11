import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../utilities/song_notifier.dart';

class BottomPlay extends StatelessWidget {
  const BottomPlay({super.key});

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
        child: ValueListenableBuilder<Map<String, dynamic>?>(
          valueListenable: SongNotifier.selectedSong,
          builder: (context, songData, child) {
            if (songData == null) {
              return const Center(
                child: Text(
                  "No Song Playing",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            final songId = songData['id'] as int;
            final songName = songData['title'] as String;
            final artistName = songData['artist'] ?? "Unknown Artist";

            return Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    /*onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NowPlayingScreen(song: songData),
                                ),
                              );
                            },*/
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: QueryArtworkWidget(
                          id: songId,
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
                        songName,
                        style: const TextStyle(
                            color: Colors.grey, fontFamily: 'melofy-font'),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        artistName,
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
                          onPressed: () {
                            // Add play functionality here
                          },
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
            );
          },
        ),
      ),
    );
  }
}
