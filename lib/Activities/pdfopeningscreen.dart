import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:hakeekat_farmer_version/Utils/utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViwer extends StatefulWidget {
  final String title;
  final String pdfUrl;
  final String swtiches;
  const PdfViwer(
      {super.key,
      required this.pdfUrl,
      required this.title,
      required this.swtiches});

  @override
  State<PdfViwer> createState() => _PdfViwerState();
}

class _PdfViwerState extends State<PdfViwer> {
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          // Padding(
          //   padding: EdgeInsets.only(right: width * 0.027),
          //   child: IconButton(
          //       onPressed: _downloadFile, icon: Icon(Icons.download)),
          // )
          Padding(
              padding: EdgeInsets.only(right: width * 0.027),
              child: downloadbutton())
        ],
        backgroundColor: AppColors.greenthemecolor,
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        scrollDirection: PdfScrollDirection.vertical,
      ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color(0xFF7455F7),
      //   onPressed: _downloadPDF,
      //   child: Icon(Icons.download),
      //   tooltip: 'Download PDF',
      // ),
    );
  }

  Future<void> _downloadFile() async {
    final dio = Dio();
    try {
      // Trigger the file picker to let the user select where to save the PDF.
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        Utils().toastMessage('PDF download canceled.');
        return;
      }

      final fileName = '${widget.title}.pdf';
      final filePath = '$selectedDirectory/$fileName';
      final file = File(filePath);

      await dio.download(
        widget.pdfUrl,
        file.path,
        onReceiveProgress: (received, total) {
          // Update UI with download progress if needed
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
          }
        },
      );

      Utils().toastMessage('Downloaded to $filePath');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download the file: $e'),
        ),
      );
    }
  }

  Widget downloadbutton() {
    if (widget.swtiches == "1") {
      return IconButton(onPressed: _downloadFile, icon: Icon(Icons.download));
    } else {
      return SizedBox();
    }
  }
}
