import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:share_plus/share_plus.dart';

class ReferEarn extends StatefulWidget {
  const ReferEarn({super.key});

  @override
  State<ReferEarn> createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
  String? referralCode;

  @override
  void initState() {
    super.initState();
    _fetchReferralCode();
  }

  Future<void> _fetchReferralCode() async {
    final code = await _walletbalance();
    setState(() {
      referralCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('Refer and Earn'),
      ),
      body: Column(
        children: [
          SizedBox(height: height * 0.02),
          Center(
            child: Text(
              'REFER MORE TO EARN MORE',
              style: TextStyle(
                  color: AppColors.greenthemecolor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          SizedBox(
            width: width * 0.8,
            child: Text(
              'Refer your friends to our app and get ₹20 for minumum recharge of ₹1000 on every successfull referral. Share the love and enjoy exclusive bonuses together!',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Center(
            child: Text(
              'Your Referral Code',
              style: TextStyle(
                  color: AppColors.greenthemecolor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800),
            ),
          ),
          referralCode != null
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    referralCode!,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: referralCode!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Referral code copied to clipboard'),
                        ),
                      );
                    },
                    icon: Icon(Icons.copy),
                  ),
                ])
              : CircularProgressIndicator(),
          Image.asset(
            'assets/refer.png',
            scale: 2,
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.15, right: width * 0.15),
            child: RoundButton(
              title: 'Refer Now',
              onTap: () {
                onShare(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<String> _walletbalance() async {
    String userEmailsDocumentId = checkUserAuthenticationType();
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmailsDocumentId);

    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    if (userDocSnapshot.exists) {
      var currentWalletValue = userDocSnapshot['ReferalId'] ?? '0';
      return currentWalletValue.toString();
    } else {
      return '0';
    }
  }

  void onShare(BuildContext context) async {
    if (referralCode != null) {
      final String textToShare =
          "Download Hakeekat App From Google Play Store.  https://play.google.com/store/apps/details?id=com.hakkikat.user and use  $referralCode  referral code and recharge for minumum ₹1000 and get ₹20 as joining bonus ";
      await Share.share(textToShare, subject: 'Sharing via Hakeekat');
    }
  }
}
