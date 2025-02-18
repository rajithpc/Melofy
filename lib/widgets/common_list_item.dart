import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CommonListItem extends StatelessWidget {
  const CommonListItem(
      {required this.song,
      required this.onButtonPressed,
      required this.onTap,
      required this.isFavorites,
      super.key});
  final SongModel song;
  final VoidCallback onButtonPressed;
  final VoidCallback onTap;
  final bool isFavorites;

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
          song.artist!,
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: 'melofy-font',
          ),
        ),
        trailing: GestureDetector(
          onTap: onButtonPressed,
          child: !isFavorites
              ? const Icon(Icons.more_vert)
              : Image.asset(
                  'assets/images/favorites.png',
                  width: 30,
                  height: 30,
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
