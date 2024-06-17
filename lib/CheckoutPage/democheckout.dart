import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakikat_app_new/OrderSucess/ordersucess.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class DemoCheckout extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double grandTotal;

  DemoCheckout({required this.cartItems, required this.grandTotal});

  @override
  State<DemoCheckout> createState() => _DemoCheckoutState();
}

class _DemoCheckoutState extends State<DemoCheckout> {
  bool isLoading = false;
  Future<void> _placeOrder(BuildContext context) async {
    setState(() {
      isLoading = true; // Set loading to true when placing the order
    });

    String userDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(userDocumentId);

    // Generate document ID using the current datetime in epoch milliseconds
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    // Create the order data
    Map<String, dynamic> orderData = {
      'orderId': orderId,
      'items': widget.cartItems,
      'total': widget.grandTotal,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Create a batch write
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Add the order to the 'orders' collection
    batch.set(FirebaseFirestore.instance.collection('orders').doc(orderId),
        orderData);

    // Update the user's 'my orders' list in the batch
    batch.update(userDocRef, {
      'my orders': FieldValue.arrayUnion([orderId])
    });

    // Commit the batch
    await batch.commit();

    // Decrease quantities in parallel
    await _decreaseQuantities(widget.cartItems);

    // Delete cart items
    await _deleteCartItem();

    // Show confirmation message
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Order placed successfully!'),
    //   ),
    // );

    setState(() {
      isLoading = false; // Set loading to false after placing the order
    });

    // Navigate back or to another screen
    nextScreenReplace(context, OrderSucess());
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: width * 0.1,
                ),
                Text('Delivery address'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.85,
                  height: height * 0.07532,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Icon(Icons.home_filled),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Home'), Text('N-1/8 GKA')],
                      ),
                      Spacer(),
                      Icon(Icons.expand_more),
                      SizedBox(
                        width: width * 0.03,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Text('Payment Mode'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.85,
                      height: height * 0.07532,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Icon(Icons.wallet),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Cash On Delivery')],
                          ),
                          Spacer(),
                          SizedBox(
                            width: width * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Text('Order Summary'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.85,
                      // height: height * 0.07532,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.01,
                          ),
                          ListView.builder(
                            shrinkWrap:
                                true, // Add this line to prevent the ListView from taking up extra space
                            itemCount: widget.cartItems.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> item =
                                  widget.cartItems[index];
                              return ListTile(
                                title: Text(item['Product Title']),
                                subtitle: Text(item['Product Subtitle']),
                                trailing: Text(
                                  '₹${item['Product Price']} x ${item['quantity']}',
                                ),
                              );
                            },
                          ),
                          Divider(),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Total: ₹${widget.grandTotal}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: IconButton(
        onPressed: () {
          _placeOrder(context);
        },
        icon: isLoading
            ? CircularProgressIndicator()
            : Container(
                width: width * 0.879,
                height: height * 0.074,
                decoration: ShapeDecoration(
                  color: AppColors.greenthemecolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                      color: Color(0xFFFCFCFC),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                      height: 0.06,
                    ),
                  ),
                )),
      ),
    );
  }

  Future<void> _deleteCartItem() async {
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    // Delete all documents in the "Cart" collection
    WriteBatch batch = FirebaseFirestore.instance.batch();
    QuerySnapshot cartSnapshot = await userDocRef.collection('Cart').get();
    cartSnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });
    await batch.commit();

    // Clear the cartItems list and reset grandTotal
    setState(() {
      widget.cartItems.clear();
    });
  }
}

Future<void> _decreaseQuantities(List<Map<String, dynamic>> cartItems) async {
  List<Future<void>> futures = [];

  for (var item in cartItems) {
    String itemId = item['id'];
    int orderedQuantity = item['quantity'];

    futures.add(_decreaseQuantityForItem(itemId, orderedQuantity));
  }

  await Future.wait(futures);
}

Future<void> _decreaseQuantityForItem(
    String itemId, int orderedQuantity) async {
  DataSnapshot snapshot =
      await FirebaseDatabase.instance.ref().child(itemId).get();

  if (snapshot.value != null) {
    Map<dynamic, dynamic> itemData = snapshot.value as Map<dynamic, dynamic>;

    int currentQuantity = int.parse(itemData['Product Stock']);
    int newQuantity = currentQuantity - orderedQuantity;

    await FirebaseDatabase.instance
        .ref()
        .child(itemId)
        .update({'Product Stock': newQuantity.toString()});
  }
}
