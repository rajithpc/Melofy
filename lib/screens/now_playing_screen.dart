import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db_functions/music_model.dart'; // Import Hive if needed
import 'dart:typed_data'; // For Uint8List

class NowPlayingScreen extends StatefulWidget {
  final List<MusicModel> songs; // List of MusicModel objects
  final int currentIndex; // Current song index

  const NowPlayingScreen({
    Key? key,
    required this.songs,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  int currentIndex = 0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Future<Uint8List?>? _artworkFuture; // Future to cache artwork

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    currentIndex = widget.currentIndex;
    _artworkFuture =
        _getArtwork(widget.songs[currentIndex].id); // Fetch artwork
    _playSong(widget.songs[currentIndex].path);

    // Listen to audio player events
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  Future<Uint8List?> _getArtwork(int id) async {
    final OnAudioQuery audioQuery = OnAudioQuery();
    return await audioQuery.queryArtwork(id, ArtworkType.AUDIO);
  }

  void _playSong(String songPath) async {
    await audioPlayer.play(DeviceFileSource(songPath));
    setState(() {
      isPlaying = true;
    });
  }

  void _pauseSong() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void _playNextSong() {
    if (currentIndex < widget.songs.length - 1) {
      currentIndex++;
      setState(() {
        _artworkFuture =
            _getArtwork(widget.songs[currentIndex].id); // Update artwork
      });
      _playSong(widget.songs[currentIndex].path);
    }
  }

  void _playPreviousSong() {
    if (currentIndex > 0) {
      currentIndex--;
      setState(() {
        _artworkFuture =
            _getArtwork(widget.songs[currentIndex].id); // Update artwork
      });
      _playSong(widget.songs[currentIndex].path);
    }
  }

  void _seekToPosition(Duration position) async {
    await audioPlayer.seek(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MusicModel currentSong = widget.songs[currentIndex];
    final songName = currentSong.title.split('|').first.trim();
    final artistName =
        (currentSong.artist == "<unknown>" || currentSong.artist == null)
            ? "Unknown Artist"
            : currentSong.artist!.split(',').first.trim();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Song name and artist
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: 40,
                      color: Colors.grey,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),

            // Artwork
            FutureBuilder<Uint8List?>(
              future: _artworkFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.grey,
                      size: 100,
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      snapshot.data!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  return Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.grey,
                      size: 100,
                    ),
                  );
                }
              },
            ),
            const Spacer(),

            songName.length < 25
                ? Column(
                    children: [
                      Text(
                        songName,
                        style: const TextStyle(
                          fontFamily: 'melofy-font',
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        artistName,
                        style: const TextStyle(
                          fontFamily: 'melofy-font',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                : Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Text(
                            songName,
                            style: const TextStyle(
                              fontFamily: 'melofy-font',
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          artistName,
                          style: const TextStyle(
                            fontFamily: 'melofy-font',
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
            const Spacer(),
            // Progress slider
            Slider(
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble(),
              onChanged: (value) {
                _seekToPosition(Duration(seconds: value.toInt()));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_position),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(_formatDuration(_duration),
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    size: 40,
                    color: Colors.grey,
                  ),
                  onPressed: _playPreviousSong,
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40, color: Colors.grey),
                  onPressed: () {
                    if (isPlaying) {
                      _pauseSong();
                    } else {
                      _playSong(currentSong.path);
                    }
                  },
                ),
                IconButton(
                  icon:
                      const Icon(Icons.skip_next, size: 40, color: Colors.grey),
                  onPressed: _playNextSong,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
