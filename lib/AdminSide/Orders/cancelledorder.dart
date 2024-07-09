import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CancelledOrdersScreen extends StatefulWidget {
  @override
  _CancelledOrdersScreenState createState() => _CancelledOrdersScreenState();
}

class _CancelledOrdersScreenState extends State<CancelledOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancelled Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Refund Pending'),
            Tab(text: 'Refund Issued'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(refundStatus: false),
          _buildOrderList(refundStatus: true),
        ],
      ),
    );
  }

  Widget _buildOrderList({required bool refundStatus}) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'Cancelled')
          .where('refund', isEqualTo: refundStatus)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data!.docs;

        if (orders.isEmpty) {
          return Center(child: Text('No orders found'));
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index].data() as Map<String, dynamic>;
            return Padding(
              padding: EdgeInsets.only(top: height * 0.02),
              child: CancelledOrderItem(order: order),
            );
          },
        );
      },
    );
  }
}

class CancelledOrderItem extends StatefulWidget {
  final Map<String, dynamic> order;

  CancelledOrderItem({required this.order});

  @override
  _CancelledOrderItemState createState() => _CancelledOrderItemState();
}

class _CancelledOrderItemState extends State<CancelledOrderItem> {
  bool isExpanded = false;
  String mobileNo = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    extractMobileNo();
  }

  Future<void> issueRefund() async {
    final orderId = widget.order['orderId'];
    final total = widget.order['total'];
    final userId = widget.order['email'];
    print(userId);

    try {
      // Fetch the current wallet balance
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (!userSnapshot.exists) {
        throw Exception('User not found');
      }

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      double currentWalletBalance = double.parse(userData['Wallet'] ?? '0');
      double newWalletBalance = currentWalletBalance + total;

      // Create a new batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Reference to the order document
      DocumentReference orderRef =
          FirebaseFirestore.instance.collection('orders').doc(orderId);

      // Reference to the user document
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);

      // Reference to the new transaction document
      DocumentReference transactionRef =
          userRef.collection('transactions').doc();

      // Update order's refund status
      batch.update(orderRef, {'refund': true});

      // Add new transaction
      batch.set(transactionRef, {
        'amount': total,
        'bonus': '0',
        'type': 'Credit',
        'date': FieldValue.serverTimestamp(),
      });

      // Update user's wallet with the new balance
      batch.update(userRef, {
        'Wallet': newWalletBalance.toStringAsFixed(2),
      });

      // Commit the batch
      await batch.commit();

      // Refresh the widget state
      setState(() {});

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refund issued successfully')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error issuing refund: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    final orderId = widget.order['orderId'];
    final total = widget.order['total'];
    final timestamp = formatTimestamp(widget.order['timestamp']);
    final address = widget.order['address'];
    final items = widget.order['items'];
    final refundStatus =
        widget.order['refund'] ? 'Refund Issued' : 'Refund Pending';

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            width: width * 0.9,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(isExpanded ? 0 : 20),
                bottomRight: Radius.circular(isExpanded ? 0 : 20),
              ),
              color: Colors.grey.withOpacity(0.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Order ID: '),
                    Text(' $orderId',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: height * 0.005),
                Row(
                  children: [
                    Text('Total:'),
                    Text(' ₹$total',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Text('Date: $timestamp'),
                SizedBox(height: height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mobile: $mobileNo',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.call, color: AppColors.greenthemecolor),
                      onPressed: () => _launchDialer(mobileNo),
                    ),
                  ],
                ),
                Text('Address: $address',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: height * 0.01),
                Row(
                  children: [
                    Text('Status: '),
                    Text(' $refundStatus',
                        style: TextStyle(
                            color: AppColors.greenthemecolor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.grey.withOpacity(0.2),
            ),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, itemIndex) {
                    final item = items[itemIndex];
                    final productTitle = item['Product Title'];
                    final productSubtitle = item['Product Subtitle'];
                    final productPrice = item['Product Price'];
                    final quantity = item['quantity'];

                    return ListTile(
                      title: Text(productTitle),
                      subtitle: Text(productSubtitle),
                      trailing: Text('₹$productPrice x $quantity'),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!widget.order['refund'])
                      ElevatedButton(
                        onPressed: issueRefund,
                        child: Text('Issue Refund'),
                        style: ElevatedButton.styleFrom(
                            //  primary: AppColors.greenthemecolor,
                            ),
                      ),
                  ],
                )
              ],
            ),
          ),
      ],
    );
  }

  void extractMobileNo() {
    final addressParts = widget.order['address'].split(',');
    if (addressParts.isNotEmpty) {
      mobileNo = addressParts.last.trim();
      // Remove the mobile number from the address
      print(mobileNo);
    }
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';

    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is String) {
      dateTime = DateTime.parse(timestamp);
    } else {
      return 'Invalid Date';
    }

    return DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
  }

  Future<void> _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
