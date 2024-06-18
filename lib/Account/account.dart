import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Account/addressscreen.dart';
import 'package:hakikat_app_new/Account/components/accountmenu.dart';
import 'package:hakikat_app_new/AdminSide/adminpanel.dart';
import 'package:hakikat_app_new/Auth/login.dart';
import 'package:hakikat_app_new/OrderSucess/myorder.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? _selectedAddress;
  final auth = FirebaseAuth.instance;
  String userName = '';
  String userEmail = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                CircleAvatar(
                  radius: 30,
                  child: Image.asset(
                    'assets/profile.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        color: Color(0xFF181725),
                        fontSize: 20,
                        fontFamily: 'Gilroy-Bold',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(
                        color: Color(0xFF7C7C7C),
                        fontSize: 16,
                        fontFamily: 'Gilroy-Regular',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
                Spacer()
              ],
            ),
            SizedBox(height: height * 0.05),
            Divider(),
            AccountMenuCard(
              img: 'orders',
              title: 'My Orders',
              ontap: () {
                nextScreen(context, MyOrdersScreen());
              },
            ),
            Divider(),
            AccountMenuCard(
              img: 'delivery',
              title: 'Delivery Addreess',
              ontap: () {
                _navigateToAddressScreen(context);
              },
            ),
            Divider(),
            AccountMenuCard(
              img: 'notification',
              title: 'Notifications',
              ontap: () {
                Utils().toastMessage('Currently Under Dev');
              },
            ),
            Divider(),
            AccountMenuCard(
              img: 'notification',
              title: 'Admin (Only For Developer)',
              ontap: () {
                nextScreen(context, AdminPanel());
              },
            ),
            Divider(),
            AccountMenuCard(
              img: 'help',
              title: 'Help',
              ontap: () {
                Utils().toastMessage('Currently Under Dev');
              },
            ),
            Divider(),
            AccountMenuCard(
              img: 'about',
              title: 'About',
              ontap: () {
                Utils().toastMessage('Currently Under Dev');
              },
            ),
            Divider(),
            SizedBox(
              height: height * 0.05,
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            auth.signOut().then(
                              (value) {
                                nextScreenReplace(context, LoginScreen());
                              },
                            );
                          },
                          child: Text('Log Out'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Container(
                width: width * 0.879,
                height: height * 0.0779,
                decoration: ShapeDecoration(
                  color: Color(0xFFF2F3F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Icon(
                      Icons.logout,
                      color: AppColors.greenthemecolor,
                    ),
                    Spacer(),
                    Text(
                      'Log Out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF53B175),
                        fontSize: 18,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                      ),
                    ),
                    Spacer(),
                    Spacer()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchUserData() async {
    String userDocumentId = checkUserAuthenticationType();

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userDocumentId)
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        userName = userData['Name'] ?? '';
        userEmail = userData['Email'] ?? '';
      });
    }
  }

  Future<void> _navigateToAddressScreen(BuildContext context) async {
    final selectedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressScreen(
          onAddressSelected: (address) {
            setState(() {
              _selectedAddress = address;
            });
          },
        ),
      ),
    );

    if (selectedAddress != null) {
      setState(() {
        _selectedAddress = selectedAddress;
      });
    }
  }
}
