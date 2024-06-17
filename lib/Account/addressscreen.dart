import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Account/addadress.dart';
import 'package:hakikat_app_new/Account/components/selectaddresscard.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class AddressScreen extends StatefulWidget {
  final Function(String) onAddressSelected;

  AddressScreen({required this.onAddressSelected});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String? selectedAddress;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Address'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserAddressesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final addresses = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: height * 0.02,
                    );
                  },
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    String userDocumentId = checkUserAuthenticationType();
                    final address =
                        addresses[index].data() as Map<String, dynamic>;
                    final addressString = address['addressLine1'] +
                        ' , ' +
                        address['addressLine2'] +
                        ' ,' +
                        address['city'] +
                        ' ,' +
                        address['pincode'];
                    final documentId =
                        addresses[index].id; // Get the document ID

                    return Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.04, right: width * 0.03),
                      child: SelectAddressCard(
                        no: address['mobileNo'],
                        name: address['name'],
                        addressLine1: address['addressLine1'],
                        addressLine2: address['addressLine2'],
                        city: address['city'],
                        pincode: address['pincode'],
                        selectedAddress: selectedAddress == addressString,
                        onAddressSelected: (value) {
                          setState(() {
                            selectedAddress = value ? addressString : null;
                          });
                        },
                        onDeleteAddress: () {
                          // Delete the address document from Firestore
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(userDocumentId)
                              .collection('addresses')
                              .doc(documentId)
                              .delete();
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              IconButton(
                onPressed: () {
                  nextScreen(context, AddAddress());
                },
                icon: Container(
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Icon(Icons.add),
                      Text('Add New Address'),
                      SizedBox(
                        height: height * 0.02,
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: IconButton(
        onPressed: () {
          if (selectedAddress != null) {
            widget.onAddressSelected(selectedAddress!);
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please select an address'),
              ),
            );
          }
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
          child: Center(
            child: Text(
              'Save and Continue',
              style: TextStyle(
                color: Color(0xFFFCFCFC),
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getUserAddressesStream() {
    String userDocumentId = checkUserAuthenticationType();
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userDocumentId)
        .collection('addresses')
        .snapshots();
  }
}
