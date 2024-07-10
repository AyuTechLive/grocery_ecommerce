import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';

class FarmerApplicationReview extends StatelessWidget {
  final String applicationId;

  FarmerApplicationReview({required this.applicationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Application Review'),
        backgroundColor: AppColors.greenthemecolor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('FarmerOrganicApplication')
            .doc(applicationId)
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _approveApplication(context),
                      child: Text('Approve'),
                      style: ElevatedButton.styleFrom(//primary: Colors.green
                          ),
                    ),
                    ElevatedButton(
                      onPressed: () => _rejectApplication(context),
                      child: Text('Reject'),
                      style: ElevatedButton.styleFrom(//primary: Colors.red
                          ),
                    ),
                  ],
                ),
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

  void _approveApplication(BuildContext context) {
    // Implement approval logic here
    FirebaseFirestore.instance
        .collection('FarmerOrganicApplication')
        .doc(applicationId)
        .update({'status': 'approved'}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application approved successfully')),
      );
      Navigator.pop(context);
    });
  }

  void _rejectApplication(BuildContext context) {
    // Implement rejection logic here
    FirebaseFirestore.instance
        .collection('FarmerOrganicApplication')
        .doc(applicationId)
        .update({'status': 'rejected'}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application rejected')),
      );
      Navigator.pop(context);
    });
  }
}
