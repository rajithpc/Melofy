import 'package:flutter/material.dart';
import 'package:melofy/db_functions/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'bottom_sheet.dart';

enum ScreenType { allSongs, recents, favorites, playlistSongs, mostlyPlayed }

class CommonListItem extends StatelessWidget {
  const CommonListItem(
      {required this.song,
      required this.onButtonPressed,
      required this.onTap,
      required this.screenType,
      super.key});
  final MusicModel song;
  final VoidCallback onButtonPressed;
  final VoidCallback onTap;
  final ScreenType screenType;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: QueryArtworkWidget(
            id: song.id,
            type: ArtworkType.AUDIO,
            artworkBorder: BorderRadius.zero,
            artworkFit: BoxFit.cover,
            nullArtworkWidget: Container(
              width: 50,
              height: 50,
              color: Colors.grey,
              child: const Icon(
                Icons.music_note,
                size: 30,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ),
        title: Text(
          song.title.length > 30
              ? '${song.title.substring(0, 30)}...'
              : song.title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'melofy-font',
          ),
        ),
        subtitle: Text(
          song.artist == "<unknown>" || song.artist == null
              ? "Unknown Artist"
              : song.artist!.split(',').first.trim(),
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: 'melofy-font',
          ),
        ),
        trailing: screenType.index == 0 ||
                screenType.index == 1 ||
                screenType.index == 4
            ? BottomSheetWidget(
                song: song,
                screenType: screenType,
                onButtonPressed: onButtonPressed,
              )
            : GestureDetector(
                onTap: onButtonPressed,
                child: Icon(
                  screenType.index == 2 ? Icons.favorite : Icons.more_vert,
                  color: Colors.grey,
                ),
              ),
        onTap: onTap,
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(70, 0, 20, 0),
        child: Divider(
          thickness: 0.2,
          color: Colors.grey,
        ),
      ),
    ]);
  }
}
