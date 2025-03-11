import 'package:flutter/material.dart';
import 'package:melofy/widgets/favorite_widget.dart';

import '../utilities/now_playing_controller.dart';

class PlaybackControls extends StatelessWidget {
  final NowPlayingController controller;

  const PlaybackControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            icon: controller.repeatEnabled
                ? const Icon(
                    Icons.repeat_one_rounded,
                    size: 25,
                    color: Colors.green,
                  )
                : controller.shuffleEnabled
                    ? const Icon(
                        Icons.shuffle,
                        size: 25,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.repeat,
                        size: 25,
                        color: Colors.green,
                      ),
            onPressed: controller.toggleValues),
        IconButton(
            icon: const Icon(
              Icons.skip_previous_rounded,
              size: 30,
              color: Colors.white,
            ),
            onPressed: controller.playPreviousSong),
        IconButton(
            icon: Icon(
              controller.isPlaying ? Icons.pause_circle : Icons.play_circle,
              size: 70,
              color: Colors.white,
            ),
            onPressed: controller.togglePlayPause),
        IconButton(
            icon: const Icon(
              Icons.skip_next_rounded,
              size: 30,
              color: Colors.white,
            ),
            onPressed: controller.playNextSong),
        FavoriteWidget(song: controller.currentSong),
      ],
    );
  }
}
