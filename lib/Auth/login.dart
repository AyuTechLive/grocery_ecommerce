import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hakikat_app_new/Auth/forgotpassword.dart';
import 'package:hakikat_app_new/Auth/loginwithphoneno.dart';
import 'package:hakikat_app_new/Auth/signup.dart';
import 'package:hakikat_app_new/Home/mainpage.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formfield = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool _isPasswordVisible = false;
  bool loading = false;

  final _auth = FirebaseAuth.instance;
  final CollectionReference controllerCollection =
      FirebaseFirestore.instance.collection('Controllers');

  @override
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  Future<String> fetchIsLoginValue() async {
    try {
      DocumentSnapshot documentSnapshot = await controllerCollection
          .doc('MobileNoLogin')
          .get(); // Assuming 'islogin' is a boolean field
      String isLogin = documentSnapshot['Isloginactivated'];

      return isLogin;
      // Use the value of isLogin as needed
    } catch (error) {
      return error.toString();
    }
  }

  void login() {
    setState(() {
      loading = true;
    });

    _auth // login succesful to then function mei chala jayega warna on error mei chala jayegaa
        .signInWithEmailAndPassword(
            email: emailcontroller.text.toString(),
            password: passwordcontroller.text.toString())
        .then(
      (value) {
        setState(() {
          loading = true;
        });
        //    Utils().toastMessage('Login succesful');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ));
      },
    ).onError(
      (error, stackTrace) {
        setState(() {
          loading = false;
        });

        // Utils().toastMessage(error.toString());
      },
    );
  }

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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                'E-mail',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
              ),
              Form(
                  key: _formfield,
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.04125,
                      ),
                      TextFormField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              borderSide: BorderSide(
                                  color: AppColors.greenthemecolor, width: 3)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                                color: AppColors.greenthemecolor, width: 3),
                          ),
                          //helperText: 'Enter your email',
                          prefixIcon: Icon(
                            Icons.alternate_email,
                            color: AppColors.greenthemecolor,
                          ),
                          iconColor: AppColors.greenthemecolor,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: height * 0.04125,
                      ),
                      Text(
                        'Password',
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
                        controller: passwordcontroller,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: AppColors.greenthemecolor,
                                    width: 3)),
                            prefixIcon: Icon(
                              Icons.lock_clock_outlined,
                              color: AppColors.greenthemecolor,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? (Icons.visibility)
                                      : Icons.visibility_off,
                                  color: _isPasswordVisible
                                      ? AppColors
                                          .greenthemecolor // Color when password is visible
                                      : AppColors.greenthemecolor,
                                ))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(),
                                    ));
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: AppColors.greenthemecolor,
                                    fontWeight: FontWeight.w500),
                              ))
                        ],
                      )
                    ],
                  )),
              SizedBox(
                height: height * 0.05875,
              ),
              RoundButton(
                loading: loading,
                title: 'Log In',
                onTap: () {
                  if (_formfield.currentState!.validate()) {
                    login();
                  }
                },
              ),
              SizedBox(
                height: height * 0.02125,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpNew(),
                          ));
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.greenthemecolor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.0375,
              ),
              FutureBuilder<String>(
                future: fetchIsLoginValue(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(); // or any other loading indicator
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // If isLogin value is '1', show InkWell, else show nothing
                    if (snapshot.data == '1') {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginWithPhoneNo(),
                            ),
                          );
                        },
                        child: Container(
                          height: height * 0.0625,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text('Login With Phone No'),
                          ),
                        ),
                      );
                    } else {
                      return Container(); // or return null
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
