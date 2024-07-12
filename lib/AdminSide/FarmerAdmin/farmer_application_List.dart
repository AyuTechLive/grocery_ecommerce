import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/farmerapplication_review.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class FarmerApplicationsList extends StatefulWidget {
  @override
  State<FarmerApplicationsList> createState() => _FarmerApplicationsListState();
}

class _FarmerApplicationsListState extends State<FarmerApplicationsList> {
  final secondFirebaseFirestore =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Applications'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: secondFirebaseFirestore
            .collection('FarmerApplications')
            .orderBy('submissionDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No applications found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ExpansionTile(
                  title: Text(
                    '${data['email']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Status: ${data['status'] ?? 'Pending'}'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Membership Number: ${data['membershipNumber']}'),
                          Text(
                              'Submission Date: ${_formatDate(data['submissionDate'])}'),
                          SizedBox(height: 8),
                          Text('Uploaded Documents:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          _buildDocumentsList(data['documents'] ?? {}),
                          SizedBox(height: 16),
                          ElevatedButton(
                            child: Text('Review Application'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FarmerApplicationReview(
                                      applicationId: doc.id),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              //primary: AppColors.greenthemecolor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDocumentsList(Map<String, dynamic> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: documents.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(left: 16, top: 4),
          child: Text('• ${entry.key}'),
        );
      }).toList(),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    return timestamp
        .toDate()
        .toString()
        .split(' ')[0]; // Returns just the date part
  }
}
