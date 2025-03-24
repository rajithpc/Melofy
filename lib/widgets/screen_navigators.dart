import 'package:flutter/material.dart';
import 'package:melofy/screens/all_songs.dart';
import 'package:melofy/screens/mostly_played.dart';
import 'package:melofy/screens/playlist.dart';
import 'package:melofy/screens/recent.dart';
import 'package:melofy/widgets/navigation_item.dart';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (screenName != "All Songs")
              NavigationItem(
                  icon: Icons.my_library_music_rounded,
                  onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllSongsScreen()),
                        (Route<dynamic> route) => false,
                      ),
                  title: 'All Songs',
                  boxColor: Colors.blueAccent),
            if (screenName != "Recent")
              NavigationItem(
                  icon: Icons.av_timer_rounded,
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Recent(),
                        ),
                      ),
                  title: "Recent",
                  boxColor: Colors.orangeAccent),
            if (screenName != "Favorites")
              NavigationItem(
                  icon: Icons.favorite_rounded,
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Favorites(),
                        ),
                      ),
                  title: 'Favorites',
                  boxColor: Colors.purpleAccent),
            if (screenName != "Playlist")
              NavigationItem(
                  icon: Icons.library_music_outlined,
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Playlist(),
                        ),
                      ),
                  title: "Playlist",
                  boxColor: Colors.greenAccent),
            if (screenName != "Mostly played songs")
              NavigationItem(
                  icon: Icons.star_border_purple500,
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MostlyPlayed(),
                        ),
                      ),
                  title: "Most played",
                  boxColor: Colors.black),
          ],
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                screenName,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'melofy-font',
                  fontSize: 20,
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

  // Widget _buildNavItem(
  //     BuildContext context, String iconPath, String title, VoidCallback onTap) {
  //   return SizedBox(
  //     width: 200,
  //     child: GestureDetector(
  //       onTap: onTap,
  //       child: Column(
  //         children: [
  //           Image.asset(iconPath, width: 40, height: 40),
  //           Text(
  //             title,
  //             style: const TextStyle
  //               fontFamily: 'melofy-font',
  //               fontSize: 20,
  //               color: Colors.grey,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
