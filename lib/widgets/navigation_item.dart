import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  const NavigationItem(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.title,
      required this.boxColor});
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color boxColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: onTap,
            child: Column(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                //Image.asset(iconPath, width: 14, height: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'melofy-font',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
