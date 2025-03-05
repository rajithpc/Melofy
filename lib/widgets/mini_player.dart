import 'package:flutter/material.dart';
import 'package:melofy/screens/now_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../utilities/now_playing_controller.dart';

class MiniPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NowPlayingController>(
      builder: (context, controller, child) {
        if (controller.songs.isEmpty) {
          return SizedBox.shrink(); // Hide mini player if no songs
        }

        final song = controller.currentSong; // Ensure we have a valid song

        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) =>
            //           NowPlayingScreen(controller: controller)),
            // );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(8),
                  nullArtworkWidget: const Icon(Icons.music_note,
                      size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(song.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis),
                      Text(song.artist ?? "Unknown Artist",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                      controller.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white,
                      size: 35),
                  onPressed: controller.togglePlayPause,
                ),
                IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 35),
                    onPressed: controller.playNextSong),
              ],
            ),
          ),
        );
      },
    );
  }
}
