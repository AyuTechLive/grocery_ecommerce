import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class MembershipApplicationReview extends StatefulWidget {
  final String applicationId;

  MembershipApplicationReview({required this.applicationId});

  @override
  State<MembershipApplicationReview> createState() =>
      _MembershipApplicationReviewState();
}

class _MembershipApplicationReviewState
    extends State<MembershipApplicationReview> {
  final secondFirebaseFirestore =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Review'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: secondFirebaseFirestore
            .collection('SanastaApplication')
            .doc(widget.applicationId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Application not found'));
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard('Personal Information', [
                  _buildInfoRow('Name', data['name']),
                  _buildInfoRow(
                      'Father\'s/Husband\'s Name', data['fatherName']),
                  _buildInfoRow('Aadhar Number', data['aadharNumber']),
                  _buildInfoRow('Bhamashah Number', data['bhamashahNumber']),
                  _buildInfoRow('Mobile Number', data['mobileNumber']),
                  _buildInfoRow('WhatsApp Number', data['whatsappNumber']),
                  _buildInfoRow('Email', data['email']),
                  _buildInfoRow('Occupation', data['occupation']),
                ]),
                _buildInfoCard('Address Information', [
                  _buildInfoRow('Village/Ward', data['village']),
                  _buildInfoRow('City', data['city']),
                  _buildInfoRow('Gram Panchayat', data['gramPanchayat']),
                  _buildInfoRow('Tehsil', data['tehsil']),
                  _buildInfoRow('District', data['district']),
                  _buildInfoRow('State', data['state']),
                  _buildInfoRow('Pin Code', data['pinCode']),
                ]),
                _buildInfoCard('Documents', [
                  _buildDocumentsList(data['documents'] ?? {}),
                ]),
                SizedBox(height: 20),
                _buildActionButtons(context, data['status']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(Map<String, dynamic> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: documents.entries.map((entry) {
        return ListTile(
          title: Text(entry.key),
          trailing: ElevatedButton(
            child: Text('View'),
            onPressed: () => _launchURL(entry.value),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open document')),
      );
    }
  }

  Widget _buildActionButtons(BuildContext context, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (status != 'accepted')
          ElevatedButton(
            onPressed: () => _updateApplicationStatus(context, 'accepted'),
            child: Text('Approve', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenthemecolor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ElevatedButton(
          onPressed: () => _updateApplicationStatus(context, 'rejected'),
          child: Text('Reject', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updateApplicationStatus(
      BuildContext context, String status) async {
    try {
      await secondFirebaseFirestore
          .collection('SanastaApplication')
          .doc(widget.applicationId)
          .update({'status': status});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Application ${status == 'accepted' ? 'accepted' : 'rejected'} successfully')),
      );

      // If you want to pop the screen after updating, uncomment the next line
      // Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating application status: $e')),
      );
    }
  }
}
