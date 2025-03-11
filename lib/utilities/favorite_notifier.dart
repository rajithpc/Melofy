import 'package:flutter/material.dart';
import 'package:melofy/db_functions/music_model.dart';

// Global ValueNotifier to hold the favorites list
ValueNotifier<List<MusicModel>> favoriteSongsNotifier = ValueNotifier([]);
