import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Cart/components/carttile.dart';
import 'package:hakikat_app_new/CheckoutPage/checkoutpage.dart';
import 'package:hakikat_app_new/CheckoutPage/democheckout.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double grandTotal = 0.0;
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    QuerySnapshot cartSnapshot = await userDocRef.collection('Cart').get();

    List<Map<String, dynamic>> fetchedCartItems = [];

    for (QueryDocumentSnapshot doc in cartSnapshot.docs) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> cartItem = {
        'id': doc.id,
        'quantity': docData['quantity'] ?? 1,
      };

      DataSnapshot productSnapshot =
          await FirebaseDatabase.instance.ref().child(doc.id).get();

      if (productSnapshot.value != null) {
        Map<dynamic, dynamic> productData =
            productSnapshot.value as Map<dynamic, dynamic>;
        Map<String, dynamic> productDataStringKeys = productData.map(
          (key, value) => MapEntry(key.toString(), value),
        );

        cartItem.addAll({
          'Product Title': productDataStringKeys['Product Title'] ?? '',
          'Product Subtitle': productDataStringKeys['Product Subtitle'] ?? '',
          'Product Price': productDataStringKeys['Product Price'] ?? '',
          'Product Img': productDataStringKeys['Product Img'] ?? '',
        });
      }

      fetchedCartItems.add(cartItem);
    }

    setState(() {
      cartItems = fetchedCartItems;
      grandTotal = 0.0; // Reset grandTotal before calculating
      for (var item in cartItems) {
        double itemTotal =
            (int.parse(item['Product Price']).toDouble() * item['quantity']);
        grandTotal += itemTotal;
      }
      isLoading = false; // Data loading completed
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Cart'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(child: Text('No items in your cart'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> item = cartItems[index];
                          return Dismissible(
                              key: Key(item['id']),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.delete, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm"),
                                      content: Text(
                                          "Are you sure you want to delete this item?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) {
                                _deleteCartItem(item['id']);
                              },
                              child: CartTile(
                                onremove: () async {
                                  bool shouldDelete =
                                      await _showDeleteConfirmationDialog(
                                          context, item['id']);
                                  if (shouldDelete) {
                                    _deleteCartItem(item['id']);
                                  }
                                },
                                title: item['Product Title'] ?? '',
                                subtitle: item['Product Subtitle'] ?? '',
                                price: (int.parse(item['Product Price']) *
                                            item['quantity'])
                                        .toString() ??
                                    '',
                                quantity: item['quantity'],
                                img: item['Product Img'],
                              ));
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        nextScreen(
                            context,
                            DemoCheckout(
                                cartItems: cartItems, grandTotal: grandTotal));
                      },
                      icon: Container(
                        width: width * 0.879,
                        height: height * 0.074,
                        decoration: ShapeDecoration(
                          color: AppColors.greenthemecolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Spacer(),
                            Text(
                              'Go to Checkout',
                              style: TextStyle(
                                color: Color(0xFFFCFCFC),
                                fontSize: 18,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                                height: 0.06,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "₹" + grandTotal.toString(),
                              style: TextStyle(
                                color: Color(0xFFFCFCFC),
                                fontSize: 18,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                                height: 0.06,
                              ),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    )
                  ],
                ),
    );
  }

  Future<void> _deleteCartItem(String itemId) async {
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    await userDocRef.collection('Cart').doc(itemId).delete();

    // Remove the item from the cartItems list and recalculate grandTotal
    setState(() {
      Map<String, dynamic> removedItem =
          cartItems.firstWhere((item) => item['id'] == itemId);
      cartItems.removeWhere((item) => item['id'] == itemId);

      double removedItemTotal =
          (int.parse(removedItem['Product Price']).toDouble() *
              removedItem['quantity']);
      grandTotal -= removedItemTotal;
    });
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, String itemId) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _deleteCartItem(itemId);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
