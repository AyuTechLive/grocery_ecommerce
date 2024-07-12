import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hakeekat_farmer_version/Home/MainPage.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:hakeekat_farmer_version/Utils/widget.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class SansthaDocumentUploadScreen extends StatefulWidget {
  final Map<String, dynamic> formData;

  SansthaDocumentUploadScreen({required this.formData});

  @override
  _SansthaDocumentUploadScreenState createState() =>
      _SansthaDocumentUploadScreenState();
}

class _SansthaDocumentUploadScreenState
    extends State<SansthaDocumentUploadScreen> {
  final List<String> requiredDocuments = [
    'Aadhar Card',
    'PAN Card',
    'Bank Statement',
    'Voter Card or Driving License',
    'Passport Size Photo',
    'Educational Qualification Documents',
    'Proof of Residence (Birth Place Address)',
    'Jamabandi and Farmer Certificate',
  ];

  Map<String, String> uploadedDocuments = {};
  String? currentlyUploadingDocument;

  Future<void> pickAndUploadFile(String documentType) async {
    if (currentlyUploadingDocument != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please wait for the current upload to finish')),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result.files.single.path!;
      String fileName = path.basename(filePath);

      setState(() {
        currentlyUploadingDocument = documentType;
      });

      try {
        // Upload file to Firebase Storage
        Reference ref =
            FirebaseStorage.instance.ref('sanstha_documents/$fileName');
        await ref.putFile(File(filePath));

        // Get download URL
        String downloadURL = await ref.getDownloadURL();

        setState(() {
          uploadedDocuments[documentType] = downloadURL;
          currentlyUploadingDocument = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$documentType uploaded successfully')),
        );
      } catch (e) {
        setState(() {
          currentlyUploadingDocument = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading $documentType: $e')),
        );
      }
    }
  }

  Future<void> submitAllData() async {
    if (uploadedDocuments.length != requiredDocuments.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload all required documents')),
      );
      return;
    }

    try {
      // Combine form data and document data
      Map<String, dynamic> allData = {
        ...widget.formData,
        'documents': uploadedDocuments,
      };

      // Generate a new UUID
      String docId = Uuid().v4();
      allData['id'] = docId;

      // Submit to Firestore
      await FirebaseFirestore.instance
          .collection('SanastaApplication')
          .doc(docId)
          .set(allData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application submitted successfully')),
      );
      nextScreenReplace(context, MainPage());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting application: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Documents'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: requiredDocuments.length,
        itemBuilder: (context, index) {
          String docType = requiredDocuments[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(docType),
              trailing: currentlyUploadingDocument == docType
                  ? CircularProgressIndicator()
                  : uploadedDocuments.containsKey(docType)
                      ? Icon(Icons.check, color: Colors.green)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenthemecolor),
                          child: Text(
                            'Upload',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: currentlyUploadingDocument == null
                              ? () => pickAndUploadFile(docType)
                              : null,
                        ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          child: Text(
            'Submit All Documents',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenthemecolor,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: currentlyUploadingDocument == null ? submitAllData : null,
        ),
      ),
    );
  }
}
