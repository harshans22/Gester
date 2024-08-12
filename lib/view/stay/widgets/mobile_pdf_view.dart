import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewMobile extends StatefulWidget {
  final String pdfURL;
  const PDFViewMobile({super.key, required this.pdfURL});

  @override
  State<PDFViewMobile> createState() => _PDFViewMobileState();
}

class _PDFViewMobileState extends State<PDFViewMobile> {
 
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openData(
        // Load the PDF from a URL
        NetworkAssetBundle(Uri.parse(widget.pdfURL)).load(widget.pdfURL).then(
              (byteData) => byteData.buffer.asUint8List(),
            ),
      ),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PdfViewPinch(
      controller: _pdfController,
    );
  }
}
