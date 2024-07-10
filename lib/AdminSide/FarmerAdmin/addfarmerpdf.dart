import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/utils.dart';

class Addpdf extends StatefulWidget {
  const Addpdf({Key? key}) : super(key: key);

  @override
  State<Addpdf> createState() => _AddpdfState();
}

class _AddpdfState extends State<Addpdf> {
  bool loading = false;
  final secondFirebaseDatabase =
      FirebaseDatabase.instanceFor(app: Firebase.app('secondary'));
  final subjectController = TextEditingController();
  final pdfNameController = TextEditingController();
  final pdfTitleController = TextEditingController();
  final pdfSubtitleController = TextEditingController();
  final pdfUrlController = TextEditingController();
  late DatabaseReference databaseRef;
  late FirebaseStorage storage;

  @override
  void initState() {
    super.initState();
    databaseRef = secondFirebaseDatabase.ref('Pdf');
    storage = FirebaseStorage.instance;
  }

  Future<void> pickAndUploadPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      String destination = 'Pdfs/$fileName';

      try {
        setState(() {
          loading = true;
        });
        SettableMetadata metadata = SettableMetadata(
          contentType: 'application/pdf',
        );

        TaskSnapshot snapshot =
            await storage.ref(destination).putFile(file, metadata);

        String pdfUrl = await snapshot.ref.getDownloadURL();
        pdfUrlController.text = pdfUrl;

        Utils().toastMessage('PDF uploaded successfully');
      } on FirebaseException catch (e) {
        Utils().toastMessage('Failed to upload PDF: ${e.message}');
      } finally {
        setState(() {
          loading = false;
        });
      }
    } else {
      Utils().toastMessage('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('Add Pdf File'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.03),
              TextFormField(
                controller: subjectController,
                decoration: InputDecoration(
                  hintText: 'Enter Your Subject',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: height * 0.03),
              TextFormField(
                controller: pdfNameController,
                decoration: InputDecoration(
                  hintText: 'PDF name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: height * 0.03),
              TextFormField(
                controller: pdfTitleController,
                decoration: InputDecoration(
                  hintText: 'Enter Your PDF Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: height * 0.03),
              TextFormField(
                controller: pdfSubtitleController,
                decoration: InputDecoration(
                  hintText: 'Enter Your PDF Subtitle',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: height * 0.03),
              TextFormField(
                controller: pdfUrlController,
                decoration: InputDecoration(
                  hintText: 'PDF URL (Auto-filled after upload)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.upload_file),
                    onPressed: pickAndUploadPdf,
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: height * 0.05),
              RoundButton(
                loading: loading,
                title: 'Add PDF',
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef.child(id).set({
                    'id': id,
                    'Subject': subjectController.text,
                    'PDF Name': pdfNameController.text,
                    'Title': pdfTitleController.text,
                    'Subtitle': pdfSubtitleController.text,
                    'Pdf Link': pdfUrlController.text
                  }).then(
                    (value) {
                      Utils().toastMessage('PDF Successfully Added');
                      setState(() {
                        loading = false;
                        // Clear all text fields
                        subjectController.clear();
                        pdfNameController.clear();
                        pdfTitleController.clear();
                        pdfSubtitleController.clear();
                        pdfUrlController.clear();
                      });
                    },
                  ).catchError((error) {
                    Utils().toastMessage('Error: $error');
                    setState(() {
                      loading = false;
                    });
                  });
                },
              ),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
