import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hakeekat_farmer_version/Auth/login.dart';
import 'package:hakeekat_farmer_version/Utils/roundbutton.dart';

class LoginWithPhoneNo extends StatefulWidget {
  const LoginWithPhoneNo({super.key});

  @override
  State<LoginWithPhoneNo> createState() => _LoginWithPhoneNoState();
}

class _LoginWithPhoneNoState extends State<LoginWithPhoneNo> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phonenocontroller = TextEditingController();
  final namecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.055, vertical: height * 0.1),
          child: Column(
            children: [
              Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
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
                keyboardType: TextInputType.number,
                controller: phonenocontroller,
                decoration: InputDecoration(
                    hintText: 'Mobile Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide:
                            BorderSide(color: Color(0xFFF17306), width: 3)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide:
                          BorderSide(color: Color(0xFFF17306), width: 3),
                    ),
                    //helperText: 'Enter your email',
                    prefixIcon: Icon(
                      Icons.call,
                      color: Color(0xFFF17306),
                    ),
                    iconColor: Color(0xFFF17306)),
              ),
              SizedBox(
                height: height * 0.0425,
              ),
              Text(
                'Name',
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
                height: height * 0.04125,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: namecontroller,
                decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide:
                            BorderSide(color: Color(0xFFF17306), width: 3)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide:
                          BorderSide(color: Color(0xFFF17306), width: 3),
                    ),
                    //helperText: 'Enter your email',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xFFF17306),
                    ),
                    iconColor: Color(0xFFF17306)),
              ),
              SizedBox(
                height: 80,
              ),
              RoundButton(
                loading: loading,
                title: 'Send OTP',
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  auth.verifyPhoneNumber(
                      phoneNumber: '+91' + phonenocontroller.text,
                      verificationCompleted: (_) {
                        setState(() {
                          loading = false;
                        });
                      },
                      verificationFailed: (e) {
                        setState(() {
                          loading = false;
                        });
                        //  Utils().toastMessage(e.toString());
                      },
                      codeSent: (String verificationId, int? token) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => VerifyCode(
                        //         verificationId: verificationId,
                        //         mobno:
                        //             '+91' + phonenocontroller.text.toString(),
                        //         name: namecontroller.text,
                        //       ),
                        //     ));
                        setState(() {
                          loading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e) {
                        //  Utils().toastMessage(e.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                },
              ),
              SizedBox(
                height: height * 0.1,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
                child: Container(
                  height: height * 0.0625,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black)),
                  child: Center(
                    child: Text('Login With Email ID'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
