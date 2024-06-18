import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/utils.dart';

class EditAddressScreen extends StatefulWidget {
  final Map<String, dynamic> addressData;

  EditAddressScreen({required this.addressData});

  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _cityController;
  late TextEditingController _pincodeController;
  late TextEditingController _nameController;
  late TextEditingController _mobileNoController;
  bool isupdating = false;
  bool isdeleting = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _addressLine1Controller =
        TextEditingController(text: widget.addressData['addressLine1']);
    _addressLine2Controller =
        TextEditingController(text: widget.addressData['addressLine2']);
    _cityController = TextEditingController(text: widget.addressData['city']);
    _pincodeController =
        TextEditingController(text: widget.addressData['pincode']);
    _nameController = TextEditingController(text: widget.addressData['name']);
    _mobileNoController =
        TextEditingController(text: widget.addressData['mobileNo']);
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _nameController.dispose();
    _mobileNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: _nameController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: _addressLine1Controller,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address line 1';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Street Address, PO, Company Name',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greenthemecolor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: _addressLine2Controller,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address line 2';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Apartment, Building floor etc',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greenthemecolor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: _cityController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'City',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: _pincodeController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pincode';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Pincode',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: _mobileNoController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                SizedBox(height: height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              AppColors.greenthemecolor)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateAddress();
                        }
                      },
                      child: isupdating
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Update Address',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        deleteAddress();
                      },
                      child: isdeleting
                          ? CircularProgressIndicator()
                          : Text('Delete Address'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateAddress() {
    setState(() {
      isupdating = true;
    });
    String userDocumentId = checkUserAuthenticationType();
    String documentId = widget.addressData['id'];

    Map<String, dynamic> updatedAddress = {
      'addressLine1': _addressLine1Controller.text,
      'addressLine2': _addressLine2Controller.text,
      'city': _cityController.text,
      'pincode': _pincodeController.text,
      'name': _nameController.text,
      'mobileNo': _mobileNoController.text,
    };

    FirebaseFirestore.instance
        .collection('Users')
        .doc(userDocumentId)
        .collection('addresses')
        .doc(documentId)
        .update(updatedAddress)
        .then(
      (value) {
        setState(() {
          isupdating = false;
        });
        Utils().toastMessage('Address Updated Successfully');
        Navigator.pop(context);
      },
    ).catchError((error) => print('Failed to update address: $error'));
  }

  void deleteAddress() {
    String userDocumentId = checkUserAuthenticationType();
    String documentId = widget.addressData['id'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Address'),
          content: Text('Are you sure you want to delete this address?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isdeleting = true;
                });
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userDocumentId)
                    .collection('addresses')
                    .doc(documentId)
                    .delete()
                    .then(
                  (value) {
                    setState(() {
                      isdeleting = false;
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ).catchError(
                        (error) => print('Failed to delete address: $error'));
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
