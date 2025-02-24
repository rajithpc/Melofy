import 'package:shared_preferences/shared_preferences.dart';

import '../db_functions/db_crud_functions.dart';
import '../db_functions/music_model.dart';

class MusicIdStorage {
  static const String _key = 'MusicId'; // Key for storing the integer

  // Save an integer in SharedPreferences
  static Future<void> saveMusicId(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, value); // Store the integer with a key
  }

  // Retrieve the integer from SharedPreferences
  static Future<int?> getMusicID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key); // Retrieve the integer by key
  }

  static Future<MusicModel?> getMusicModel() async {
    int? id = await MusicIdStorage.getMusicID();

    if (id == null) return null;

    return HiveDatabase.getSongById('musicBox', id);
  }
}
