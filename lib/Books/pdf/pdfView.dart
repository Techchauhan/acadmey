import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// Inside your book card onTap handler:


// PdfViewerPage widget to display the PDF:
class PdfViewerPage extends StatelessWidget {
  final String pdfUrl;

  PdfViewerPage(this.pdfUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Container(
         child: SfPdfViewer.network(pdfUrl),
      ),
    );
  }
}
