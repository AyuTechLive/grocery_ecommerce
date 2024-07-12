import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SubmissionScreen extends StatelessWidget {
  final Map<String, dynamic> formData;

  SubmissionScreen({required this.formData});

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _uuid = Uuid();

  Future<void> _submitAllData(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to submit a form')),
      );
      return;
    }

    String docId = _uuid.v4();

    try {
      // Prepare final data for submission
      Map<String, dynamic> allData = {
        ...formData,
        'id': docId,
        'email': user.email,
        'status': 'pending',
        'submissionDate': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await _firestore
          .collection('FarmerOrganicApplication')
          .doc(docId)
          .set(allData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form and documents submitted successfully')),
      );

      // Navigate back to the main screen
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting form and documents: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review and Submit'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Review Your Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              // Display form data summary
              ...formData.entries
                  .where((entry) => entry.key != 'documents')
                  .map(
                    (entry) => ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    ),
                  ),
              SizedBox(height: 20),
              Text('Uploaded Documents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              // Display uploaded document names
              if (formData['documents'] != null)
                ...formData['documents'].entries.map(
                      (entry) => ListTile(
                        title: Text(entry.key),
                        trailing: Icon(Icons.check_circle, color: Colors.green),
                      ),
                    )
              else
                Text('No documents uploaded'),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Submit All'),
                onPressed: () => _submitAllData(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
