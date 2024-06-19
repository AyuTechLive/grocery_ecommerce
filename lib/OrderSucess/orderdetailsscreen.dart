import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hakikat_app_new/OrderSucess/components/myordertile.dart';
import 'package:hakikat_app_new/OrderSucess/myorder.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderData orderData;

  const OrderDetailsScreen({Key? key, required this.orderData})
      : super(key: key);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Order ID:',
                ),
                Text(
                  ' ${orderData.orderId}',
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
                    'Address:   ${orderData.address}',
                    //  style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text('Total: ₹${orderData.total}',
                style: TextStyle(fontWeight: FontWeight.w800)),
            SizedBox(height: height * 0.04),
            Text(
              'Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...orderData.items.map((item) {
              return ListTile(
                leading: Image.network(item['Product Img']),
                trailing: Text('₹' + item['Product Price'] * item['quantity']),
                title: Text(item['Product Title']),
                subtitle:
                    Text('₹${item['Product Price']} x ${item['quantity']}'),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Text('Help?'),
    );
  }
}
