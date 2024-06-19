import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrderHistoryScreen extends StatefulWidget {
  @override
  _AdminOrderHistoryScreenState createState() =>
      _AdminOrderHistoryScreenState();
}

class _AdminOrderHistoryScreenState extends State<AdminOrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'Shipping')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return Center(
              child: Text('No orders found'),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = order['orderId'];
              final total = order['total'];
              final timestamp = order['timestamp'];
              final address = order['address'];
              final items = order['items'];
              final orderStatus = order['orderStatus'] ?? 'Pending';

              return ExpansionTile(
                title: Text('Order ID: $orderId'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: ₹$total'),
                    Text('Timestamp: $timestamp'),
                    Text('Address: $address'),
                    Text('Status: $orderStatus'),
                  ],
                ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _updateOrderStatus(orderId, 'Shipping');
                        },
                        child: Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _updateOrderStatus(orderId, 'Cancelled');
                        },
                        child: Text('Reject'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _updateOrderStatus(orderId, 'Delivered');
                        },
                        child: Text('Completed'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _updateOrderStatus(String orderId, String status) {
    FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': status,
    }).then((_) {
      // Show a success message or perform any additional actions
      print('Order status updated to $status');
    }).catchError((error) {
      // Show an error message or perform any necessary error handling
      print('Failed to update order status: $error');
    });
  }
}
