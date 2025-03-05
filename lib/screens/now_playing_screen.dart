import 'package:flutter/material.dart';
import '../db_functions/music_model.dart';
import '../services/playback_controls.dart';
import '../utilities/now_playing_controller.dart';
import '../widgets/artwork_widget.dart';
import '../widgets/bottom_sheet.dart';
import '../widgets/progressbar_widget.dart';

class NowPlayingScreen extends StatefulWidget {
  final List<MusicModel> songs;
  final int currentIndex;

  const NowPlayingScreen({
    Key? key,
    required this.songs,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late NowPlayingController controller;
  bool isAddToDB = true;

  @override
  void initState() {
    super.initState();
    controller = NowPlayingController(
      widget.songs,
      widget.currentIndex,
      () {
        setState(() {});
      },
    );
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTopBar(context),
            ArtworkWidget(controller: controller),
            _buildSongDetails(),
            ProgressBarWidget(controller: controller),
            PlaybackControls(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down_sharp,
                size: 40, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
          BottomSheetAddToDB(
            song: controller.currentSong,
          ),
        ],
      ),
    );
  }

  Widget _buildSongDetails() {
    final song = controller.currentSong;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            song.title.split('|').first.trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'melofy-font',
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Text(
            song.artist == "<unknown>" || song.artist == null
                ? "Unknown Artist"
                : song.artist!.split(',').first.trim(),
            style: const TextStyle(
                fontFamily: 'melofy-font', fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
