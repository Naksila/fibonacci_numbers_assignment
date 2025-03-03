import 'package:flutter/material.dart';

class CradItem extends StatelessWidget {
  final void Function() onTap;
  final bool highlightKey;
  final String title;
  final String? subTitle;
  final IconData icon;
  final Color? colorHighlight;

  const CradItem({
    super.key,
    required this.onTap,
    required this.highlightKey,
    required this.title,
    this.subTitle,
    required this.icon,
    this.colorHighlight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: highlightKey ? colorHighlight : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  subTitle ?? '',
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            Icon(
              icon,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
