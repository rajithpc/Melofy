import 'package:flutter/foundation.dart';

class SongNotifier {
  static final ValueNotifier<Map<String, dynamic>?> selectedSong =
      ValueNotifier<Map<String, dynamic>?>(null);
}
