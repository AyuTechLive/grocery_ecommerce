import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hakikat_app_new/Cart/components/carttile.dart';
import 'package:hakikat_app_new/Utils/appimg.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/responsive_helper.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double grandTotal = 0.0;
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  double walletBalance = 0;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
    _fetchUserWalletBalance();
  }

  Future<void> _fetchCartItems() async {
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    try {
      QuerySnapshot cartSnapshot = await userDocRef.collection('Cart').get();

      if (cartSnapshot.docs.isEmpty) {
        if (mounted) {
          setState(() {
            cartItems = [];
            grandTotal = 0.0;
            isLoading = false;
          });
        }
        return;
      }

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
            'Product Img': (productDataStringKeys['Product Img'] != null &&
                    productDataStringKeys['Product Img'].isNotEmpty)
                ? productDataStringKeys['Product Img'][0]
                : AppImage.defaultimgurl,
          });
        }

        fetchedCartItems.add(cartItem);
      }

      if (mounted) {
        setState(() {
          cartItems = fetchedCartItems;
          grandTotal = 0.0;
          for (var item in cartItems) {
            double itemTotal = (int.parse(item['Product Price']).toDouble() *
                item['quantity']);
            grandTotal += itemTotal;
          }
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching cart items: $e");
      if (mounted) {
        setState(() {
          cartItems = [];
          grandTotal = 0.0;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    final isWeb = kIsWeb;

    return Scaffold(
      appBar: isWeb
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              title: Text('Cart'),
            ),
      body: ResponsiveWidget(
        mobile: _buildMobileLayout(height, width),
        tablet: _buildTabletLayout(height, width),
        desktop: _buildDesktopLayout(height, width),
      ),
    );
  }

  Widget _buildMobileLayout(double height, double width) {
    return isLoading
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
                        return _buildCartItem(item, height, width);
                      },
                    ),
                  ),
                  _buildCheckoutButton(height, width),
                  SizedBox(height: height * 0.01)
                ],
              );
  }

  Widget _buildTabletLayout(double height, double width) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : cartItems.isEmpty
            ? Center(child: Text('No items in your cart'))
            : Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Shopping Cart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> item = cartItems[index];
                            return _buildCartItem(item, height, width);
                          },
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: _buildCheckoutButton(height, width),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              );
  }

  Widget _buildDesktopLayout(double height, double width) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : cartItems.isEmpty
            ? Center(child: Text('No items in your cart'))
            : Padding(
                padding: EdgeInsets.all(32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cart Items
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shopping Cart',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> item = cartItems[index];
                                return _buildCartItem(item, height, width);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 32),
                    // Order Summary
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Summary',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Items (${cartItems.length})'),
                                Text('₹${grandTotal.toStringAsFixed(2)}'),
                              ],
                            ),
                            Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '₹${grandTotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.greenthemecolor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: _buildCheckoutButton(height, width),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget _buildCartItem(
      Map<String, dynamic> item, double height, double width) {
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
              content: Text("Are you sure you want to delete this item?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
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
              await _showDeleteConfirmationDialog(context, item['id']);
          if (shouldDelete) {
            _deleteCartItem(item['id']);
          }
        },
        title: item['Product Title'] ?? '',
        subtitle: item['Product Subtitle'] ?? '',
        price:
            (int.parse(item['Product Price']) * item['quantity']).toString() ??
                '',
        quantity: item['quantity'],
        img: item['Product Img'],
      ),
    );
  }

  Widget _buildCheckoutButton(double height, double width) {
    return IconButton(
      onPressed: () {
        AppRoutes.goToCheckout(
          context,
          cartItems,
          grandTotal,
          walletBalance.toString(),
        );
      },
      icon: Container(
        width: kIsWeb ? double.infinity : width * 0.879,
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
              "₹${grandTotal.toStringAsFixed(2)}",
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
    );
  }

  Future<void> _deleteCartItem(String itemId) async {
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    await userDocRef.collection('Cart').doc(itemId).delete();

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

  Future<void> _fetchUserWalletBalance() async {
    String userDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(userDocumentId);

    DocumentSnapshot userSnapshot = await userDocRef.get();
    if (userSnapshot.exists && mounted) {
      setState(() {
        walletBalance = double.parse(userSnapshot['Wallet'] ?? '0');
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
