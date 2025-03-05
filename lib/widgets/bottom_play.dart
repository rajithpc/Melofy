import 'package:flutter/material.dart';
import 'package:melofy/db_functions/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../screens/now_playing_screen.dart';
import '../utilities/now_playing_controller.dart';

// class BottomPlay extends StatefulWidget {
//   final List<MusicModel> songs;
//   final int currentIndex;
//   BottomPlay({
//     super.key,
//     required this.songs,
//     required this.currentIndex,
//   });

//   @override
//   State<BottomPlay> createState() => _BottomPlayState();
// }

// class _BottomPlayState extends State<BottomPlay> {
//   late NowPlayingController controller;

//   @override
//   initState() {
//     controller = NowPlayingController(widget.songs, widget.currentIndex, () {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(20),
//         topRight: Radius.circular(20),
//       ),
//       child: Container(
//           height: 100,
//           color: Colors.black,
//           child: Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () async {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => NowPlayingScreen(
//                               songs: widget.songs,
//                               currentIndex: widget.currentIndex)),
//                     );
//                   },
//                   child: ListTile(
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(10.0),
//                       child: QueryArtworkWidget(
//                         id: controller.currentSong.id,
//                         type: ArtworkType.AUDIO,
//                         artworkBorder: BorderRadius.zero,
//                         artworkFit: BoxFit.cover,
//                         nullArtworkWidget: Container(
//                           width: 50,
//                           height: 50,
//                           color: Colors.grey,
//                           child: const Icon(
//                             Icons.music_note,
//                             size: 30,
//                             color: Colors.blueGrey,
//                           ),
//                         ),
//                       ),
//                     ),
//                     title: Text(
//                       controller.currentSong.title,
//                       style: const TextStyle(
//                           color: Colors.grey, fontFamily: 'melofy-font'),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     subtitle: Text(
//                       controller.currentSong.artist!,
//                       style: const TextStyle(
//                           color: Colors.grey, fontFamily: 'melofy-font'),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.skip_previous,
//                           color: Colors.grey,
//                           size: 30,
//                         ),
//                         onPressed: () {
//                           // Add play functionality here
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(
//                           Icons.play_circle_outline,
//                           color: Colors.grey,
//                           size: 40,
//                         ),
//                         onPressed: () {},
//                       ),
//                       IconButton(
//                         icon: const Icon(
//                           Icons.skip_next,
//                           color: Colors.grey,
//                           size: 30,
//                         ),
//                         onPressed: () {
//                           // Add play functionality here
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           )),
//     );
//   }
// }
