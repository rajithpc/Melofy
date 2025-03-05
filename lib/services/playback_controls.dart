import 'package:flutter/material.dart';

import '../utilities/now_playing_controller.dart';

class PlaybackControls extends StatelessWidget {
  final NowPlayingController controller;

  const PlaybackControls({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            icon: Icon(
              Icons.repeat_one,
              size: 40,
              color: controller.repeatEnabled ? Colors.green : Colors.grey,
            ),
            onPressed: controller.repeatSongModeChage),
        IconButton(
            icon: const Icon(
              Icons.skip_previous,
              size: 40,
              color: Colors.grey,
            ),
            onPressed: controller.playPreviousSong),
        IconButton(
            icon: Icon(
              controller.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 40,
              color: Colors.grey,
            ),
            onPressed: controller.togglePlayPause),
        IconButton(
            icon: const Icon(
              Icons.skip_next,
              size: 40,
              color: Colors.grey,
            ),
            onPressed: controller.playNextSong),
        IconButton(
            icon: Icon(
              Icons.shuffle_outlined,
              size: 40,
              color: controller.shuffleEnabled ? Colors.green : Colors.grey,
            ),
            onPressed: controller.shuffleModeChage),
      ],
    );
  }
}
