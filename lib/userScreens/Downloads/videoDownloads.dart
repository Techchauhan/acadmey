import 'package:flutter/material.dart';

class VideoDownloadSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Video 1'),
          onTap: () {
            // Add logic to open/download Video 1
          },
        ),
        ListTile(
          title: Text('Video 2'),
          onTap: () {
            // Add logic to open/download Video 2
          },
        ),
        // Add more ListTile widgets for additional video files
      ],
    );
  }
}