import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:intl/intl.dart';

class AdminOrderHistoryScreen extends StatefulWidget {
  @override
  _AdminOrderHistoryScreenState createState() =>
      _AdminOrderHistoryScreenState();
}

class _AdminOrderHistoryScreenState extends State<AdminOrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _estimatetimecontroller = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _estimatetimecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Order Placed'),
            Tab(text: 'Order Confirmed'),
            Tab(text: 'Delivered'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList('Order Placed'),
          _buildOrderList('Order Confirmed'),
          _buildOrderList('Delivered'),
        ],
      ),
    );
  }

  Widget _buildOrderList(String status) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: status)
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
          // separatorBuilder: (context, index) {
          //   return SizedBox(
          //     height: height * 0.02,
          //   );
          // },
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index].data() as Map<String, dynamic>;
            return Padding(
              padding: EdgeInsets.only(top: height * 0.02),
              child: OrderItem(
                order: order,
                status: status,
                onUpdateStatus: _updateOrderStatus,
                onShowAcceptDialog: _showAcceptTextFieldDialog,
              ),
            );
          },
        );
      },
    );
  }

  void _updateOrderStatus(String orderId, String status, String estimated) {
    Map<String, dynamic> updateData = {'status': status};

    if (status == 'Cancelled') {
      updateData['refund'] = false;
    }

    if (estimated.isNotEmpty) {
      updateData['Estimated'] = estimated;
    }

    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update(updateData)
        .then((_) {
      print('Order status updated to $status');
      if (status == 'Cancelled') {
        print('Refund set to false');
      }
    }).catchError((error) {
      print('Failed to update order status: $error');
    });
  }

  void _showAcceptTextFieldDialog(String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Text'),
          content: TextField(
            controller: _estimatetimecontroller,
            decoration: InputDecoration(
              hintText: 'Enter text here',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                _updateOrderStatus(
                    orderId, 'Order Confirmed', _estimatetimecontroller.text);
                _estimatetimecontroller.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class OrderItem extends StatefulWidget {
  final Map<String, dynamic> order;
  final String status;
  final Function(String, String, String) onUpdateStatus;
  final Function(String) onShowAcceptDialog;

  OrderItem({
    required this.order,
    required this.status,
    required this.onUpdateStatus,
    required this.onShowAcceptDialog,
  });

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;

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
    final orderStatus = widget.order['status'] ?? 'Pending';

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
                    Text(
                      'Order ID: ',
                    ),
                    Text(' $orderId',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: height * 0.005),
                Row(
                  children: [
                    Text(
                      'Total:',
                    ),
                    Text(' ₹$total',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Text('Date: $timestamp'),
                SizedBox(
                  height: height * 0.01,
                ),
                Text('Address: $address',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    Text(
                      'Status: ',
                    ),
                    Text(
                      ' $orderStatus',
                      style: TextStyle(
                          color: AppColors.greenthemecolor,
                          fontWeight: FontWeight.w600),
                    ),
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
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (widget.status == 'Order Placed')
                        ElevatedButton(
                          onPressed: () => widget.onShowAcceptDialog(orderId),
                          child: Text('Accept'),
                        ),
                      if (widget.status == 'Order Placed' ||
                          widget.status == 'Order Confirmed')
                        ElevatedButton(
                          onPressed: () =>
                              widget.onUpdateStatus(orderId, 'Cancelled', ''),
                          child: Text('Reject'),
                        ),
                      if (widget.status == 'Order Confirmed')
                        ElevatedButton(
                          onPressed: () =>
                              widget.onUpdateStatus(orderId, 'Delivered', ''),
                          child: Text('Completed'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
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
}
