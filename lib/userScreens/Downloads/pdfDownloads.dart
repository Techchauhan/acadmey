import 'package:flutter/material.dart';

class PdfDownloadSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('PDF File 1'),
          onTap: () {
            // Add logic to open/download PDF File 1
          },
        ),
        ListTile(
          title: Text('PDF File 2'),
          onTap: () {
            // Add logic to open/download PDF File 2
          },
        ),
        // Add more ListTile widgets for additional PDF files
      ],
    );
  }
}