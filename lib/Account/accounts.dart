import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hakeekat_farmer_version/Account/Pageopener.dart';
import 'package:hakeekat_farmer_version/Account/components/accountmenucard.dart';
import 'package:hakeekat_farmer_version/Auth/login.dart';
import 'package:hakeekat_farmer_version/ContactUs/helpscreen.dart';
import 'package:hakeekat_farmer_version/ContactUs/paymentqr.dart';
import 'package:hakeekat_farmer_version/Events/events_page.dart';
import 'package:hakeekat_farmer_version/Utils/checkuserauthentication.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:hakeekat_farmer_version/Utils/utils.dart';
import 'package:hakeekat_farmer_version/Utils/widget.dart';

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
                    Row(
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
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: _editUserName,
                          child: Icon(Icons.edit,
                              size: 20, color: AppColors.greenthemecolor),
                        ),
                      ],
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
              img: 'notification',
              title: 'Notifications',
              ontap: () {
                Utils().toastMessage('Currently Under Dev');
              },
            ),
            // Divider(),
            // AccountMenuCard(
            //   img: 'notification',
            //   title: 'Admin (Only For Developer)',
            //   ontap: () {
            //     nextScreen(context, AdminPanel());
            //   },
            // ),
            Divider(),
            AccountMenuCard(
              img: 'help',
              title: 'Help',
              ontap: () {
                nextScreen(context, HelpScreen());
              },
            ),
            Divider(),

            AccountMenuCard(
              img: 'event',
              title: 'Events',
              ontap: () {
                nextScreen(context, EventPage());
              },
            ),
            Divider(),
            AccountMenuCard(
              img: 'about',
              title: 'Privacy Policy',
              ontap: () {
                nextScreen(
                    context,
                    PageOpener(
                        url:
                            'https://hakeekatnatural.blogspot.com/2024/07/privacy-policy.html',
                        title: 'Privacy Policy'));
              },
            ),
            Divider(),
            AccountMenuCard(
              img: 'about',
              title: 'About Us',
              ontap: () {
                nextScreen(
                    context,
                    PageOpener(
                        url:
                            'https://hakeekatnatural.blogspot.com/2024/07/about-us.html',
                        title: 'About Us'));
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
    }
  }
}
