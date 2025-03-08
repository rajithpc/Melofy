import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:melofy/db_functions/db_crud_functions.dart';
import '../db_functions/music_model.dart';

class NowPlayingController {
  static final NowPlayingController _instance =
      NowPlayingController._internal();

  factory NowPlayingController() => _instance;

  NowPlayingController._internal() {
    audioPlayer = AudioPlayer();
  }

  late List<MusicModel> songs;
  late int currentIndex;
  late Function updateUI;
  ValueNotifier<Duration> positionNotifier = ValueNotifier(Duration.zero);
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool shuffleEnabled = false;
  bool repeatEnabled = false;
  bool loopEnabled = true;

  MusicModel get currentSong => songs[currentIndex];

  void initialize(List<MusicModel> songsList, int index, Function uiUpdater) {
    songs = songsList;
    currentIndex = index;
    updateUI = uiUpdater;
    playSong(songs[currentIndex].path);

    playSong(currentSong.path);
    audioPlayer.onDurationChanged.listen((d) {
      duration = d;
    });
    audioPlayer.onPositionChanged.listen((p) {
      position = p;
      positionNotifier.value = p;
    });
    audioPlayer.onPlayerComplete.listen((_) {
      isPlaying = false;
      position = Duration.zero;
      repeatEnabled ? playSong(currentSong.path) : playNextSong();
      updateUI();
    });
  }

  void playSong(String path) async {
    await audioPlayer.play(DeviceFileSource(path));
    isPlaying = true;
    updateUI();
    HiveDatabase.updateMusic('mostlyPlayedBox', currentSong);
  }

  void togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
    isPlaying = !isPlaying;
    updateUI();
  }

  void playNextSong() {
    if (shuffleEnabled) {
      currentIndex = Random().nextInt(songs.length);
    } else if (!repeatEnabled && currentIndex < songs.length - 1) {
      currentIndex++;
    }
    playSong(currentSong.path);
  }

  void playPreviousSong() {
    if (shuffleEnabled || repeatEnabled) {
      playNextSong();
    } else if (currentIndex > 0) {
      currentIndex--;
      playSong(currentSong.path);
    }
  }

  void toggleValues() {
    if (loopEnabled) {
      repeatEnabled = true;
      shuffleEnabled = false;
      loopEnabled = false;
    } else if (repeatEnabled) {
      repeatEnabled = false;
      shuffleEnabled = true;
      loopEnabled = false;
    } else if (shuffleEnabled) {
      repeatEnabled = false;
      shuffleEnabled = false;
      loopEnabled = true;
    }
    updateUI();
  }

  void seekToPosition(Duration position) async {
    await audioPlayer.seek(position);
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
