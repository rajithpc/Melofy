import 'dart:ui';

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

  const NowPlayingScreen(
      {required this.songs, required this.currentIndex, super.key});

  @override
  NowPlayingScreenState createState() => NowPlayingScreenState();
}

class NowPlayingScreenState extends State<NowPlayingScreen> {
  bool isAddToDB = true;
  final nowPlayingController = NowPlayingController();

  @override
  void initState() {
    super.initState();
    initController();
  }

  void initController() {
    nowPlayingController.initialize(widget.songs, widget.currentIndex, () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Image.asset(
                  "assets/images/emptyImage.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTopBar(context),
                  _buildSongDetails(),
                  ArtworkWidget(controller: nowPlayingController),
                  ProgressBarWidget(controller: nowPlayingController),
                  PlaybackControls(controller: nowPlayingController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_sharp,
              size: 40, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        BottomSheetAddToDB(
          song: nowPlayingController.currentSong,
        ),
      ],
    );
  }

  Widget _buildSongDetails() {
    final song = nowPlayingController.currentSong;
    return Column(
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
    );
  }
}
