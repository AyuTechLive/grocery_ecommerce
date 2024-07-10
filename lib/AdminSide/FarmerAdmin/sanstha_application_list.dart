import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/sanstha_application_review.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:intl/intl.dart';

class SansthaApplicationList extends StatelessWidget {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership Applications'),
        backgroundColor: Colors.white,
        actions: [
          // You can add action buttons here if needed
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('SanastaApplication')
            .orderBy('submissionDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No applications found',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;

              return ApplicationCard(
                applicationId: doc.id,
                name: data['name'],
                email: data['email'],
                submissionDate: data['submissionDate'],
                status: data['status'] ?? 'Pending',
              );
            },
          );
        },
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final String applicationId;
  final String name;
  final String email;
  final Timestamp submissionDate;
  final String status;

  const ApplicationCard({
    Key? key,
    required this.applicationId,
    required this.name,
    required this.email,
    required this.submissionDate,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MembershipApplicationReview(applicationId: applicationId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              Text(
                'Name: $name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Email: $email'),
              SizedBox(height: 8),
              Text('Submission Date: ${_formatDate(submissionDate)}'),
              SizedBox(height: 8),
              Text('Status: $status'),
              const SizedBox(height: 8),
              // Add a button or action if needed
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    return DateFormat('yyyy-MM-dd').format(timestamp.toDate());
  }
}
