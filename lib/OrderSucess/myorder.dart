import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Favorites/component/favoritetile.dart';
import 'package:hakikat_app_new/OrderSucess/components/myordertile.dart';
import 'package:hakikat_app_new/OrderSucess/components/orderdetailstile.dart';
import 'package:hakikat_app_new/OrderSucess/orderdetailsscreen.dart';
import 'package:hakikat_app_new/OrderSucess/ordertrack.dart';

import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/widget.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool isLoading = true;
  bool isLoadingMore = false;
  List<OrderData> orderData = [];
  int limit = 5; // Number of documents to fetch initially
  DocumentSnapshot? lastVisible;

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
    Query ordersQuery = FirebaseFirestore.instance
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (lastVisible != null) {
      ordersQuery = ordersQuery.startAfterDocument(lastVisible!);
    }

    QuerySnapshot ordersSnapshot = await ordersQuery.get();

    for (DocumentSnapshot orderDoc in ordersSnapshot.docs) {
      Map<String, dynamic> orderData = orderDoc.data() as Map<String, dynamic>;
      if (orderIds.contains(orderData['orderId'])) {
        OrderData order = OrderData.fromMap(orderData);
        fetchedOrderData.add(order);
      }
    }

    setState(() {
      isLoading = false;
      isLoadingMore = false;
      orderData.addAll(fetchedOrderData);
      if (ordersSnapshot.docs.length == limit) {
        lastVisible = ordersSnapshot.docs.last;
      } else {
        lastVisible = null;
      }
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
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      if (lastVisible != null && !isLoadingMore) {
                        setState(() {
                          isLoadingMore = true;
                        });
                        fetchOrderDetails();
                      }
                    }
                    return true;
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
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
                                  ontaptrack: () {
                                    nextScreen(
                                        context,
                                        OrderTrack(
                                          estimated: order.estimated,
                                          orderid: order.orderId,
                                          date: formatteddate,
                                          status: order.orderstaus,
                                        ));
                                  },
                                  ontap: () {
                                    nextScreen(context,
                                        OrderDetailsScreen(orderData: order));
                                    // showOrderDetails(context, order);
                                    // showOrderDetails(context, order);
                                  },
                                  quantity: order.items.length.toString(),
                                  processing: order.orderstaus,
                                  title: order.title,
                                  price: order.total.toString(),
                                  img: order.imgurl,
                                  orderid: order.orderId,
                                  date: formatteddate,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (isLoadingMore)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
    );
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
                // return Orderdetailstile(
                //     title: item['Product Title'],
                //     subtitle: item['Product Price'],
                //     price: item['Product Price'],
                //     img: '');
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
  final String orderstaus;
  final String estimated;
  final String address;
  final List<Map<String, dynamic>> items;

  OrderData(
      {required this.title,
      required this.imgurl,
      required this.orderId,
      required this.total,
      required this.items,
      required this.orderdate,
      required this.estimated,
      required this.orderstaus,
      required this.address});

  factory OrderData.fromMap(Map<String, dynamic> map) {
    return OrderData(
      address: map['address'] ?? '',
      estimated: map['Estimated'] ?? '',
      orderstaus: map['status'],
      title: map['items'][0]['Product Title'] ?? '',
      imgurl: map['items'][0]['Product Img'] ?? '',
      orderId: map['orderId'] ?? '',
      orderdate: map['timestamp'] ?? '',
      total: map['total']?.toDouble() ?? 0.0,
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
    );
  }
}
