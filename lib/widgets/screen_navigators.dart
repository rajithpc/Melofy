import 'package:flutter/material.dart';
import 'package:melofy/screens/all_songs.dart';
import 'package:melofy/screens/mostly_played.dart';
import 'package:melofy/screens/playlist.dart';
import 'package:melofy/screens/recent.dart';
import '../screens/favorites.dart';

class ScreenNavigators extends StatelessWidget {
  final String screenName;
  final VoidCallback? onAddPlaylistPressed;

  const ScreenNavigators({
    super.key,
    required this.screenName,
    this.onAddPlaylistPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (screenName != "All Songs")
                _buildNavItem(
                  context,
                  'assets/images/all_songs.png',
                  'All Songs',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllSongsScreen()),
                  ),
                ),
              if (screenName != "Recent")
                _buildNavItem(
                  context,
                  'assets/images/recent.png',
                  'Recent',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Recent()),
                  ),
                ),
              if (screenName != "Favorites")
                _buildNavItem(
                  context,
                  'assets/images/favorites.png',
                  'Favorites',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Favorites()),
                  ),
                ),
              if (screenName != "Playlist")
                _buildNavItem(
                  context,
                  'assets/images/playlist.png',
                  'Playlist',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Playlist()),
                  ),
                ),
              if (screenName != "Mostly played songs")
                _buildNavItem(
                  context,
                  'assets/images/playlist.png',
                  'Mostly played',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MostlyPlayed()),
                  ),
                ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                screenName,
                style: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'melofy-font',
                  fontSize: 25,
                ),
              ),
              if (screenName == "Playlist")
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.grey, size: 28),
                  onPressed: onAddPlaylistPressed,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
      BuildContext context, String iconPath, String title, VoidCallback onTap) {
    return SizedBox(
      width: 200,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Image.asset(iconPath, width: 40, height: 40),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'melofy-font',
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
