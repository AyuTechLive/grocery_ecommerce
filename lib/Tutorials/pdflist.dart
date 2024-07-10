import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfListScreen extends StatefulWidget {
  @override
  _PdfListScreenState createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  final databaseReference = FirebaseDatabase.instance.ref('Pdf');
  List<PdfFile> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    fetchPdfFiles();
  }

  void fetchPdfFiles() {
    databaseReference.onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map;
      PdfFile pdfFile = PdfFile(
        id: snapshot.key ?? '',
        title: values['Title'] ?? '',
        subtitle: values['Subtitle'] ?? '',
        pdfLink: values['Pdf Link'] ?? '',
      );
      setState(() {
        pdfFiles.add(pdfFile);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pdf Tutorials',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: pdfFiles.length,
        itemBuilder: (context, index) {
          return PdfListItem(pdfFile: pdfFiles[index], index: index);
        },
      ),
    );
  }
}

class PdfListItem extends StatelessWidget {
  final PdfFile pdfFile;
  final int index;

  const PdfListItem({Key? key, required this.pdfFile, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
        ),
        title: Text(
          pdfFile.title, // Mocking dates for demonstration
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(pdfFile.subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(index),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatus(index),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => _launchPdf(pdfFile.pdfLink),
      ),
    );
  }

  Color _getStatusColor(int index) {
    switch (index) {
      case 0:
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatus(int index) {
    switch (index) {
      case 0:
      case 1:
        return 'See Now';
      case 2:
        return 'Not Healthy';
      case 3:
        return 'Harmful';
      default:
        return 'Unknown';
    }
  }

  void _launchPdf(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}

class PdfFile {
  final String id;
  final String title;
  final String subtitle;
  final String pdfLink;

  PdfFile({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.pdfLink,
  });
}
