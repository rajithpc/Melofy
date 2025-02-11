import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SongPreferenceHelper {
  static const String songKey = "selectedSong";

  // Save song data
  static Future<void> saveSong(Map<String, dynamic> songData) async {
    final prefs = await SharedPreferences.getInstance();
    String songJson = jsonEncode(songData); // Convert to JSON string
    await prefs.setString(songKey, songJson);
  }

  // Retrieve song data
  static Future<Map<String, dynamic>?> getSong() async {
    final prefs = await SharedPreferences.getInstance();
    String? songJson = prefs.getString(songKey);
    if (songJson != null) {
      return jsonDecode(songJson); // Convert back to a Map
    }
    return null;
  }

  // Clear saved song
  static Future<void> clearSong() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(songKey);
  }
}
