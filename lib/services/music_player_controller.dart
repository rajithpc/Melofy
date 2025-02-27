import 'package:just_audio/just_audio.dart';
import 'package:melofy/db_functions/music_model.dart';

class MusicPlayerController {
  final AudioPlayer audioPlayer;
  final List<MusicModel> songList;
  int currentIndex;

  MusicPlayerController({
    required this.audioPlayer,
    required this.songList,
    required this.currentIndex,
  });

  Future<void> playCurrentSong(Function updateUI) async {
    if (currentIndex < 0 || currentIndex >= songList.length) return;

    final song = songList[currentIndex];
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.data!)));
    audioPlayer.play();
    updateUI();
  }

  void playNext(Function updateUI) {
    if (currentIndex < songList.length - 1) {
      currentIndex++;
    } else {
      currentIndex = 0; // Loop back to first song
    }
    playCurrentSong(updateUI);
  }

  void playPrevious(Function updateUI) {
    if (currentIndex > 0) {
      currentIndex--;
    } else {
      currentIndex = songList.length - 1; // Loop back to last song
    }
    playCurrentSong(updateUI);
  }
}
