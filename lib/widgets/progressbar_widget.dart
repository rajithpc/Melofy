import 'package:flutter/material.dart';
import '../utilities/now_playing_controller.dart';

class ProgressBarWidget extends StatelessWidget {
  final NowPlayingController controller;

  const ProgressBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: controller.positionNotifier, // Listen for changes
      builder: (context, position, child) {
        return Column(
          children: [
            Slider(
              min: 0,
              max: controller.duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) {
                controller.seekToPosition(Duration(seconds: value.toInt()));
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(position),
                      style: const TextStyle(color: Colors.grey)),
                  Text(formatDuration(controller.duration),
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }
}
