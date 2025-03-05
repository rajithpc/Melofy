import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistItem extends StatelessWidget {
  final String playlistName;
  final int songCount;
  final int artworkId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const PlaylistItem(
      {Key? key,
      required this.playlistName,
      required this.songCount,
      required this.artworkId,
      required this.onEdit,
      required this.onDelete,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image at the top
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              child: QueryArtworkWidget(
                id: artworkId,
                type: ArtworkType.AUDIO,
                artworkWidth: 100,
                artworkHeight: 100,
                artworkFit: BoxFit.cover,
                nullArtworkWidget: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.music_note,
                      color: Colors.grey, size: 50),
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlistName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '$songCount Songs',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: onDelete,
                      child: const Icon(Icons.delete, color: Colors.grey))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
