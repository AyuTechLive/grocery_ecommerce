import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hakikat_app_new/Account/components/accountmenu.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/responsive_helper.dart';
import 'package:hakikat_app_new/Utils/utils.dart';

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
    super.initState();
    fetchUserData();
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
            ),
      body: ResponsiveWidget(
        mobile: _buildMobileLayout(height, width),
        tablet: _buildTabletLayout(height, width),
        desktop: _buildDesktopLayout(height, width),
      ),
    );
  }

  Widget _buildMobileLayout(double height, double width) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(height, width),
          SizedBox(height: height * 0.05),
          Divider(),
          ..._buildMenuItems(),
          SizedBox(height: height * 0.05),
          _buildLogoutButton(height, width),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(double height, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            _buildProfileHeader(height, width),
            SizedBox(height: height * 0.03),
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  Divider(),
                  ..._buildMenuItems(),
                  SizedBox(height: height * 0.03),
                  _buildLogoutButton(height, width),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(double height, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                _buildProfileHeader(height, width),
                SizedBox(height: height * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ..._buildMenuItems().take(6),
                        ],
                      ),
                    ),
                    SizedBox(width: 32),
                    Expanded(
                      child: Column(
                        children: [
                          ..._buildMenuItems().skip(6),
                          SizedBox(height: height * 0.03),
                          _buildLogoutButton(height, width),
                        ],
                      ),
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

  Widget _buildProfileHeader(double height, double width) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          CircleAvatar(
            radius: kIsWeb ? 40 : 30,
            child: Image.asset(
              'assets/profile.png',
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person,
                  size: kIsWeb ? 40 : 30,
                  color: AppColors.greenthemecolor,
                );
              },
            ),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    userName.isNotEmpty ? userName : 'User Name',
                    style: TextStyle(
                      color: Color(0xFF181725),
                      fontSize: kIsWeb ? 24 : 20,
                      fontFamily: 'Gilroy-Bold',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: _editUserName,
                    child: Icon(
                      Icons.edit,
                      size: kIsWeb ? 24 : 20,
                      color: AppColors.greenthemecolor,
                    ),
                  ),
                ],
              ),
              Text(
                userEmail.isNotEmpty ? userEmail : 'user@email.com',
                style: TextStyle(
                  color: Color(0xFF7C7C7C),
                  fontSize: kIsWeb ? 18 : 16,
                  fontFamily: 'Gilroy-Regular',
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          Spacer()
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    return [
      AccountMenuCard(
        img: 'orders',
        title: 'My Orders',
        ontap: () {
          context.push('/my-orders');
        },
      ),
      Divider(),
      AccountMenuCard(
        img: 'delivery',
        title: 'Delivery Address',
        ontap: () {
          context.push('/addresses');
        },
      ),
      Divider(),
      AccountMenuCard(
        img: 'walletrecharge',
        title: 'Wallet',
        ontap: () {
          context.push('/wallet');
        },
      ),
      Divider(),
      AccountMenuCard(
        img: 'walletrecharge',
        title: 'Recharge Wallet',
        ontap: () {
          context.push('/qr-payment');
        },
      ),
      Divider(),
      AccountMenuCard(
        img: 'notification',
        title: 'Refer and Earn',
        ontap: () {
          context.push('/refer-earn');
        },
      ),
      Divider(),
      AccountMenuCard(
        img: 'orders',
        title: 'Store Items',
        ontap: () {
          context.push('/pdf-list');
        },
      ),
      Divider(),
      AccountMenuCard(
        img: 'help',
        title: 'Help',
        ontap: () {
          context.push('/help');
        },
      ),
      Divider(),
      AccountMenuCard(
        img: 'event',
        title: 'Events',
        ontap: () {
          context.push('/events');
        },
      ),
      Divider(),
      AccountMenuCard(
        img: 'about',
        title: 'Privacy Policy',
        ontap: () {
          // For web, we might want to open in new tab
          if (kIsWeb) {
            // Could implement web-specific navigation
          }
          // Keep existing functionality for now
        },
      ),
      Divider(),
      AccountMenuCard(
        img: 'about',
        title: 'About Us',
        ontap: () {
          // For web, we might want to open in new tab
          if (kIsWeb) {
            // Could implement web-specific navigation
          }
          // Keep existing functionality for now
        },
      ),
      Divider(),
    ];
  }

  Widget _buildLogoutButton(double height, double width) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      child: IconButton(
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
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      auth.signOut().then((_) {
                        Navigator.of(context).pop();
                        context.go('/login');
                      });
                    },
                    child: Text('Log Out'),
                  ),
                ],
              );
            },
          );
        },
        icon: Container(
          width: kIsWeb ? 300 : width * 0.879,
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
              SizedBox(width: kIsWeb ? 20 : width * 0.1),
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

  Future<void> _editUserName() async {
    String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String updatedName = userName;
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextField(
            onChanged: (value) {
              updatedName = value;
            },
            controller: TextEditingController(text: userName),
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(updatedName);
              },
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      String userDocumentId = checkUserAuthenticationType();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userDocumentId)
          .update({'Name': newName});
      setState(() {
        userName = newName;
      });
      Utils().toastMessage('Name updated successfully');
    }
  }
}
