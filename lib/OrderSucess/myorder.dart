import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/OrderSucess/components/myordertile.dart';

import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool isLoading = true;
  List<OrderData> orderData = [];

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    String userDocumentId = checkUserAuthenticationType();

    // Get the order IDs from the "Users" collection
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userDocumentId)
        .get();

    // Cast the data to Map<String, dynamic>
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

    List<dynamic> orderIds = userData['my orders'] ?? [];

    // Fetch the order details from the "orders" collection
    List<OrderData> fetchedOrderData = [];
    for (String orderId in orderIds) {
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();

      if (orderSnapshot.exists) {
        Map<String, dynamic> orderData =
            orderSnapshot.data() as Map<String, dynamic>;
        OrderData order = OrderData.fromMap(orderData);
        fetchedOrderData.add(order);
      }
    }

    setState(() {
      isLoading = false;
      orderData = fetchedOrderData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : orderData.isEmpty
                ? Center(child: Text('You Have Not Ordered Something From Us'))
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 20,
                      );
                    },
                    itemCount: orderData.length,
                    itemBuilder: (context, index) {
                      OrderData order = orderData[index];
                      String formatteddate = timestampToFormattedDate(
                          order.orderdate, 'dd-MM-yyyy');
                      return GestureDetector(
                          onTap: () {
                            showOrderDetails(context, order);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: MyOrderTile(
                              quantity: order.items.length.toString(),
                              processing: true,
                              title: order.title,
                              price: order.total.toString(),
                              img: order.imgurl,
                              orderid: order.orderId,
                              date: formatteddate,
                            ),
                          )

                          //  ListTile(
                          //   title: Text('Order ID: ${order.orderId}'),
                          //   subtitle: Text('Total: ₹${order.total}'),
                          // ),
                          );
                    },
                  ));
  }

  void showOrderDetails(BuildContext context, OrderData order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order ID: ${order.orderId}'),
              Text('Total: ₹${order.total}'),
              SizedBox(height: 16),
              Text('Items:'),
              ...order.items.map((item) {
                return ListTile(
                  title: Text(item['Product Title']),
                  subtitle:
                      Text('₹${item['Product Price']} x ${item['quantity']}'),
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String timestampToFormattedDate(Timestamp timestamp, String format) {
    DateTime dateTime = timestamp.toDate();
    final formatter = DateFormat(format);
    return formatter.format(dateTime);
  }
}

class OrderData {
  final String imgurl;
  final String orderId;
  final double total;
  final Timestamp orderdate;
  final String title;
  final List<Map<String, dynamic>> items;

  OrderData({
    required this.title,
    required this.imgurl,
    required this.orderId,
    required this.total,
    required this.items,
    required this.orderdate,
  });

  factory OrderData.fromMap(Map<String, dynamic> map) {
    return OrderData(
      title: map['items'][0]['Product Title'] ?? '',
      imgurl: map['items'][0]['Product Img'] ?? '',
      orderId: map['orderId'] ?? '',
      orderdate: map['timestamp'] ?? '',
      total: map['total']?.toDouble() ?? 0.0,
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
    );
  }
}
