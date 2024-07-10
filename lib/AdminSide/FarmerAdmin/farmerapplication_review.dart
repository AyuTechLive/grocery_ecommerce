import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hakikat_app_new/Utils/colors.dart';

class FarmerApplicationReview extends StatefulWidget {
  final String applicationId;

  FarmerApplicationReview({required this.applicationId});

  @override
  State<FarmerApplicationReview> createState() =>
      _FarmerApplicationReviewState();
}

class _FarmerApplicationReviewState extends State<FarmerApplicationReview> {
  final secondFirebaseFirestore =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Application Review'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: secondFirebaseFirestore
            .collection('FarmerOrganicApplication')
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
                _buildInfoCard('Basic Information', [
                  _buildInfoRow('Membership Number', data['membershipNumber']),
                  _buildInfoRow('Total Land', '${data['totalLand']} बीघा'),
                  _buildInfoRow('Already Doing Organic Farming',
                      data['isAlreadyDoingOrganicFarming'] ? 'Yes' : 'No'),
                ]),
                if (data['isAlreadyDoingOrganicFarming'])
                  _buildInfoCard('Organic Farming Details', [
                    _buildInfoRow(
                        'Start Date', data['organicFarmingStartDate']),
                    _buildInfoRow('Organic Farming Land',
                        '${data['organicFarmingLand']} बीघा'),
                    _buildInfoRow(
                        'Previous Crops', data['previousCrops'].join(', ')),
                  ])
                else
                  _buildInfoCard('Planned Organic Farming', [
                    _buildInfoRow('Land for Organic Farming',
                        '${data['nonOrganicLand']} बीघा'),
                  ]),
                _buildInfoCard('Farming Details', [
                  _buildInfoRow(
                      'Start Season', data['organicFarmingStartSeason']),
                  _buildInfoRow(
                      'Khasra Numbers', data['khasraNumbers'].join(', ')),
                  _buildInfoRow('Village Location', data['villageLocation']),
                  _buildInfoRow('Panchayat Name', data['panchayatName']),
                  _buildInfoRow('State', data['state']),
                  _buildInfoRow('Distance from District HQ',
                      '${data['districtHeadquartersDistance']} km'),
                ]),
                _buildInfoCard('Livestock', [
                  ...data['livestock']
                      .entries
                      .map((e) => _buildInfoRow(e.key, e.value.toString()))
                      .toList(),
                ]),
                _buildInfoCard('Additional Information', [
                  _buildInfoRow('Want to Sell Milk',
                      data['wantToSellMilk'] ? 'Yes' : 'No'),
                  if (data['wantToSellMilk'])
                    _buildInfoRow(
                        'Milk Quantity', '${data['milkQuantity']} liters'),
                  _buildInfoRow('Makes Organic Fertilizer',
                      data['makeOrganicFertilizer'] ? 'Yes' : 'No'),
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
          .collection('FarmerOrganicApplication')
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
