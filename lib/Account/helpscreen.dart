import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Contact Information'),
            _buildContactItem(Icons.store, 'Store Basic No.', '01552261265'),
            _buildContactItem(
                Icons.shopping_cart, 'Order Related', '9672261265'),
            _buildSectionTitle('Additional Support'),
            _buildContactItem(Icons.support_agent, 'Support 1', '9414246996'),
            _buildContactItem(Icons.support_agent, 'Support 2', '9887213944'),
            _buildContactItem(Icons.support_agent, 'Support 3', '8302460001'),
            _buildContactItem(
                Icons.account_balance, 'Account Details', '7852091795'),
            SizedBox(height: 24),
            _buildSectionTitle('Operating Hours'),
            _buildTimeItem(
                Icons.access_time, 'Support Time', '10 A.M. to 4 P.M.'),
            _buildTimeItem(
                Icons.storefront, 'Store Opening', '8:30 A.M. to 8:00 P.M.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, top: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.greenthemecolor,
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String phoneNumber) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.greenthemecolor, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  phoneNumber,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.call, color: Colors.green),
            onPressed: () => _launchDialer(phoneNumber),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeItem(IconData icon, String title, String time) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.greenthemecolor, size: 28),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
