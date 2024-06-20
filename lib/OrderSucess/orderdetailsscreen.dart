import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakikat_app_new/OrderSucess/components/myordertile.dart';
import 'package:hakikat_app_new/OrderSucess/myorder.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderData orderData;

  const OrderDetailsScreen({Key? key, required this.orderData})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Future<void> _cancelOrder(String orderId) async {
    try {
      final orderRef =
          FirebaseFirestore.instance.collection('orders').doc(orderId);
      await orderRef.update({'status': 'Cancelled', 'refund': false}).then(
        (value) {
          Utils().toastMessage(
              'Order Cancelled, Refund Will Be issued in 5 working days');
          setState(() {}); // Trigger a rebuild after updating the order status
        },
      );
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Order ID:',
                  ),
                  Text(
                    ' ${widget.orderData.orderId}',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.75,
                    child: Text(
                      'Address:   ${widget.orderData.address}',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text('Total: ₹${widget.orderData.total}',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              SizedBox(height: height * 0.04),
              Text(
                'Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...widget.orderData.items.map((item) {
                return ListTile(
                  leading: Image.network(item['Product Img']),
                  trailing: Text(item['quantity'].toString()),
                  title: Text(item['Product Title']),
                  subtitle:
                      Text('₹${item['Product Price']} x ${item['quantity']}'),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.orderData.orderstaus != 'Delivered' &&
              widget.orderData.orderstaus != 'Cancelled')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Show a confirmation dialog before cancelling the order
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: Text('Cancel Order'),
                        content:
                            Text('Are you sure you want to cancel this order?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              _cancelOrder(widget.orderData.orderId).then((_) {
                                Navigator.of(dialogContext)
                                    .pop(); // Close the dialog
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => MyOrdersScreen()),
                                );
                              });
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Cancel Order'),
              ),
            ),
          SizedBox(width: 16.0),
        ],
      ),
    );
  }
}
