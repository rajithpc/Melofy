import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../utilities/now_playing_controller.dart';

class ArtworkWidget extends StatelessWidget {
  final NowPlayingController controller;

  const ArtworkWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: OnAudioQuery()
          .queryArtwork(controller.currentSong.id, ArtworkType.AUDIO),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(snapshot.data!,
              width: 300, height: 300, fit: BoxFit.cover);
        } else {
          return Container(
            width: 300,
            height: 300,
            color: Colors.grey[800],
            child: const Icon(Icons.music_note, color: Colors.grey, size: 100),
          );
        }
      },
    );
  }
}
