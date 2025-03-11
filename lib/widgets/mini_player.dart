import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../screens/now_playing_screen.dart';
import '../utilities/now_playing_controller.dart';
import 'package:marquee/marquee.dart';

class MiniPlayer extends StatefulWidget {
  @override
  State<MiniPlayer> createState() => MiniPlayerState();
  const MiniPlayer({super.key});
}

class MiniPlayerState extends State<MiniPlayer> {
  final nowPlayingController = NowPlayingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: nowPlayingController.playerNotifier,
      builder: (context, _, __) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: nowPlayingController.isControllerInitialized
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NowPlayingScreen(
                                songs: nowPlayingController.songs,
                                currentIndex: nowPlayingController.currentIndex,
                              )),
                    );
                  },
                  child: SizedBox(
                    height: 100,
                    child: Container(
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 10),
                          QueryArtworkWidget(
                            id: nowPlayingController.currentSong.id,
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(5),
                            nullArtworkWidget: const Icon(Icons.music_note,
                                size: 50, color: Colors.grey),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                nowPlayingController.currentSong.title
                                            .split('|')
                                            .first
                                            .trim()
                                            .length >
                                        20
                                    ? SizedBox(
                                        height: 25,
                                        child: Marquee(
                                          text: nowPlayingController
                                              .currentSong.title
                                              .split('|')
                                              .first
                                              .trim(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'melofy-font'),
                                          scrollAxis: Axis.horizontal,
                                          blankSpace: 30.0,
                                          velocity: 30.0,
                                          pauseAfterRound:
                                              const Duration(seconds: 1),
                                          startPadding: 0.0,
                                          accelerationDuration:
                                              const Duration(seconds: 1),
                                          accelerationCurve: Curves.easeIn,
                                          decelerationDuration:
                                              const Duration(milliseconds: 500),
                                          decelerationCurve: Curves.easeOut,
                                        ),
                                      )
                                    : Text(
                                        nowPlayingController.currentSong.title
                                            .split('|')
                                            .first
                                            .trim(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'melofy-font'),
                                      ),
                                Text(
                                    nowPlayingController.currentSong.artist ==
                                                "<unknown>" ||
                                            nowPlayingController
                                                    .currentSong.artist ==
                                                null
                                        ? "Unknown Artist"
                                        : nowPlayingController
                                            .currentSong.artist!
                                            .split(',')
                                            .first
                                            .trim(),
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontFamily: 'melofy-font'),
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.skip_previous_rounded,
                                  color: Colors.white, size: 25),
                              onPressed: () {
                                nowPlayingController.playPreviousSong();
                              }),
                          IconButton(
                              icon: Icon(
                                  nowPlayingController.isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 50),
                              onPressed: () {
                                nowPlayingController.togglePlayPause();
                              }),
                          IconButton(
                              icon: const Icon(Icons.skip_next_rounded,
                                  color: Colors.white, size: 25),
                              onPressed: () {
                                nowPlayingController.playNextSong();
                              }),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        );
      },
    );
  }
}
