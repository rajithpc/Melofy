import 'package:flutter/foundation.dart';
import 'package:melofy/db_functions/music_model.dart';

class SongNotifier {
  static final ValueNotifier<MusicModel?> selectedSong =
      ValueNotifier<MusicModel?>(null);
}
