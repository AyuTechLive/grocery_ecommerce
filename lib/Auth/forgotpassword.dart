import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hakeekat_farmer_version/Auth/login.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:hakeekat_farmer_version/Utils/roundbutton.dart';
import 'package:hakeekat_farmer_version/Utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    final emailcontroller = TextEditingController();
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.055, vertical: height * 0.1),
        child: Column(
          children: [
            Text(
              'Forgot Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w800,
                height: 0,
              ),
            ),
            SizedBox(
              height: height * 0.0425,
            ),
            Text(
              'Email',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w300,
                height: 0,
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailcontroller,
              decoration: InputDecoration(
                hintText: 'Email ID',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    borderSide:
                        BorderSide(color: AppColors.greenthemecolor, width: 3)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide:
                      BorderSide(color: AppColors.greenthemecolor, width: 3),
                ),
                //helperText: 'Enter your email',
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: AppColors.greenthemecolor,
                ),
                iconColor: AppColors.greenthemecolor,
              ),
            ),
            SizedBox(
              height: height * 0.2,
            ),
            RoundButton(
              title: 'Reset Password',
              onTap: () {
                auth
                    .sendPasswordResetEmail(
                        email: emailcontroller.text.toString())
                    .then(
                  (value) {
                    setState(() {
                      emailcontroller.clear();
                    });

                    Utils().toastMessage(
                        'Reset Link Sended to Your Email Sucessfully');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                ).onError(
                  (error, stackTrace) {
                    // Utils().toastMessage(
                    //     'Some error encountered please check your email id');
                  },
                );
              },
            )
          ],
        ),
      ),
    ));
  }
}
