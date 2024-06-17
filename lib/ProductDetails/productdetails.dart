import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Cart/cart.dart';
import 'package:hakikat_app_new/Cart/democart.dart';
import 'package:hakikat_app_new/Home/mainpage.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class ProductDetails extends StatefulWidget {
  final String title;
  final String subtitle;
  final String price;
  final String img;
  final String orderid;
  final int maxquantity;
  const ProductDetails(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.price,
      required this.maxquantity,
      required this.img,
      required this.orderid});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  int totalprice = 0;
  bool isInFavorites = false;
  bool isLoading = false;
  bool isInCart = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfInFavorites();
    totalprice = int.parse(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2F3F2),
      ),
      body: Column(
        children: [
          Container(
            width: width,
            height: height * 0.31,
            decoration: ShapeDecoration(
              color: Color(0xFFF2F3F2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
            ),
            child: Center(
              child: SizedBox(
                  width: width * 0.69,
                  height: height * 0.21,
                  child: ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.img,
                        fit: BoxFit.fill,
                      );
                    },
                  )
                  //  Image.network(
                  //   'https://firebasestorage.googleapis.com/v0/b/oneupnoobs-9ee91.appspot.com/o/Vector.png?alt=media&token=bce591e1-fb44-4596-b3ba-f5b739a8d9c1',
                  //   fit: BoxFit.fill,
                  // ),
                  ),
            ),
          ),
          Row(
            children: [
              Spacer(),
              SizedBox(
                width: width * 0.604,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Color(0xFF181725),
                    fontSize: 20,
                    fontFamily: 'Gilroy-Bold',
                    fontWeight: FontWeight.w400,
                    //letterSpacing: 0.10,
                  ),
                ),
              ),
              Spacer(),
              Spacer(),
              IconButton(
                onPressed: () {
                  toggleFavorite(widget.orderid);
                },
                icon: Icon(
                    isInFavorites
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: isInFavorites ? Colors.red : null),
              ),
              Spacer()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.1,
              ),
              Text(
                widget.subtitle,
                style: TextStyle(
                  color: Color(0xFF7C7C7C),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  //height: 0.07,
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.015,
          ),
          Row(
            children: [
              Spacer(),
              IconButton(
                onPressed: () {
                  quantitydecrement();
                },
                icon: Container(
                  width: width * 0.11,
                  height: height * 0.050,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFF0F0F0)),
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.remove),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              Text(
                quantity.toString(),
                style: TextStyle(
                  color: Color(0xFF181725),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  height: 0.07,
                  letterSpacing: 0.10,
                ),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              IconButton(
                onPressed: () {
                  quantityincrement();
                },
                icon: Container(
                  width: width * 0.11,
                  height: height * 0.050,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFF0F0F0)),
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: AppColors.greenthemecolor,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Text(
                '₹ ${totalprice}',
                style: TextStyle(
                  color: Color(0xFF181725),
                  fontSize: 18,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  height: 0.08,
                  letterSpacing: 0.10,
                ),
              ),
              Spacer()
            ],
          ),
          SizedBox(
            height: height * 0.04,
          ),
          Container(
            width: width * (0.876),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFE2E2E2),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            children: [
              SizedBox(
                width: width * 0.08,
              ),
              Text(
                'Product Detail',
                style: TextStyle(
                  color: Color(0xFF181725),
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.expand_more)),
              SizedBox(
                width: width * 0.05,
              )
            ],
          ),
          SizedBox(
            width: width * 0.864,
            child: Text(
              'Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.',
              style: TextStyle(
                color: Color(0xFF7C7C7C),
                fontSize: 13,
                fontFamily: 'Gilroy-Medium',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.04,
          ),
          Container(
            width: width * (0.876),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFE2E2E2),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          IconButton(
              onPressed: () {
                widget.maxquantity > 0
                    ? isInCart
                        ? _gotoCart()
                        : _addToCart()
                    : Utils().toastMessage('Item Out Of Stock');
              },
              icon: widget.maxquantity > 0
                  ? isLoading
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
                          child: isInCart
                              ? Center(
                                  child: Text(
                                    'Go To Cart',
                                    style: TextStyle(
                                      color: Color(0xFFFCFCFC),
                                      fontSize: 16,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w600,
                                      height: 0.06,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'Add To Cart',
                                    style: TextStyle(
                                      color: Color(0xFFFCFCFC),
                                      fontSize: 16,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w600,
                                      height: 0.06,
                                    ),
                                  ),
                                ),
                        )
                  : Container(
                      width: width * 0.879,
                      height: height * 0.074,
                      decoration: ShapeDecoration(
                        color: Colors.red.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Out Of Stock',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                            height: 0.06,
                          ),
                        ),
                      ),
                    )),
        ],
      ),
    );
  }

  void quantityincrement() {
    if (quantity < widget.maxquantity) {
      setState(() {
        quantity++;
        totalprice = int.parse(widget.price) * quantity;
      });
    }
  }

  void quantitydecrement() {
    if (quantity > 0) {
      setState(() {
        quantity--;
        totalprice = int.parse(widget.price) * quantity;
      });
    }
  }

  Future<void> _addToCart() async {
    setState(() {
      isLoading = true; // Set loading to true
    });
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    if (userDocSnapshot.exists) {
      DocumentReference cartDocRef =
          userDocRef.collection('Cart').doc(widget.orderid);

      cartDocRef.set({
        'id': widget.orderid,
        'quantity': quantity,
        // Add any other fields you need for the cart item
      }, SetOptions(merge: true)).then((value) {
        setState(() {
          isLoading = false;
          isInCart = true;
          //  Utils().toastMessage('Item added to cart');
        });
      }).catchError((error) {
        setState(() {
          isLoading = false; // Set loading to false in case of error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding item to cart: $error'),
          ),
        );
      });
    } else {
      setState(() {
        isLoading = false; // Set loading to false in case of error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding item to cart'),
        ),
      );
    }
  }

  Future<void> toggleFavorite(String productid) async {
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    if (userDocSnapshot.exists) {
      if (isInFavorites) {
        await userDocRef.update({
          'Favorites': FieldValue.arrayRemove([productid])
        }).then((value) {
          setState(() {
            isInFavorites = false;
            Utils().toastMessage('Item removed from Favorites');
          });
        });
      } else {
        await userDocRef.update({
          'Favorites': FieldValue.arrayUnion([productid])
        }).then((value) {
          setState(() {
            isInFavorites = true;
            Utils().toastMessage('Item added to Favorites');
          });
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insufficient balance to join the match'),
        ),
      );
    }
    await checkIfInFavorites();
  }

  Future<void> checkIfInFavorites() async {
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    if (userDocSnapshot.exists) {
      List<dynamic> favorites = userDocSnapshot.get('Favorites') ?? [];
      isInFavorites = favorites.contains(widget.orderid); // Add this line
      setState(() {
        isInFavorites;
      });
    }
  }

  _gotoCart() {
    nextScreen(context, CartScreen());
  }
}
