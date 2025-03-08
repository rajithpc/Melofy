import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../screens/now_playing_screen.dart';
import '../utilities/now_playing_controller.dart';
import 'package:marquee/marquee.dart';

class MiniPlayer extends StatefulWidget {
  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final nowPlayingController = NowPlayingController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: GestureDetector(
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
                              child: Expanded(
                                child: Marquee(
                                  text: nowPlayingController.currentSong.title
                                      .split('|')
                                      .first
                                      .trim(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  blankSpace: 30.0,
                                  velocity: 30.0,
                                  pauseAfterRound: const Duration(seconds: 1),
                                  startPadding: 0.0,
                                  accelerationDuration:
                                      const Duration(seconds: 1),
                                  accelerationCurve: Curves.easeIn,
                                  decelerationDuration:
                                      const Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                            )
                          : Text(nowPlayingController.currentSong.title
                              .split('|')
                              .first
                              .trim()),
                      Text(
                          nowPlayingController.currentSong.artist ==
                                      "<unknown>" ||
                                  nowPlayingController.currentSong.artist ==
                                      null
                              ? "Unknown Artist"
                              : nowPlayingController.currentSong.artist!
                                  .split(',')
                                  .first
                                  .trim(),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.skip_previous,
                        color: Colors.white, size: 35),
                    onPressed: () {
                      nowPlayingController.playPreviousSong();
                      setState(() {});
                    }),
                IconButton(
                    icon: Icon(
                        nowPlayingController.isPlaying
                            ? Icons.play_circle_filled
                            : Icons.pause_circle_filled,
                        color: Colors.white,
                        size: 35),
                    onPressed: () {
                      nowPlayingController.togglePlayPause();
                      setState(() {});
                    }),
                IconButton(
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 35),
                    onPressed: () {
                      nowPlayingController.playNextSong();
                      setState(() {});
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
