import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hakeekat_farmer_version/Auth/login.dart';
import 'package:hakeekat_farmer_version/Home/MainPage.dart';
import 'package:hakeekat_farmer_version/Utils/roundbutton.dart';
import 'package:hakeekat_farmer_version/Utils/utils.dart';

import 'package:hakeekat_farmer_version/Utils/colors.dart';

class SignUpNew extends StatefulWidget {
  const SignUpNew({super.key});

  @override
  State<SignUpNew> createState() => _SignUpNewState();
}

class _SignUpNewState extends State<SignUpNew> {
  bool loading = false;
  final _formfield = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  bool _isPasswordVisible = false;
  final referalcodecontroller = TextEditingController();

  // final databaseref = FirebaseDatabase.instance;
  var username = '';

  FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('Users');
  final fireStore2 = FirebaseFirestore.instance.collection('Referals');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    DateTime currentDate = DateTime.now();
    String formattedDate =
        '${currentDate.day}-${currentDate.month}-${currentDate.year}';
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: height * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sign Up',
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
              Form(
                  key: _formfield,
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.04125,
                      ),
                      TextFormField(
                        controller: namecontroller,
                        decoration: const InputDecoration(
                            hintText: 'Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                    color: AppColors.greenthemecolor,
                                    width: 3)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color: AppColors.greenthemecolor, width: 3),
                            ),
                            //helperText: 'Enter your email',
                            prefixIcon: Icon(
                              Icons.perm_identity,
                              color: AppColors.greenthemecolor,
                            )),
                      ),
                      SizedBox(
                        height: height * 0.04,
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
                        controller: emailcontroller,
                        decoration: const InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                    color: AppColors.greenthemecolor,
                                    width: 3)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color: AppColors.greenthemecolor, width: 3),
                            ),
                            //helperText: 'Enter your email',
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              color: AppColors.greenthemecolor,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Text(
                        'Referal Code',
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
                        controller: referalcodecontroller,
                        decoration: const InputDecoration(
                            hintText: 'Referal Code',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                    color: AppColors.greenthemecolor,
                                    width: 3)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color: AppColors.greenthemecolor, width: 3),
                            ),
                            //helperText: 'Enter your email',
                            prefixIcon: Icon(Icons.group_add,
                                color: AppColors.greenthemecolor)),
                      ),
                      SizedBox(
                        height: height * 0.04,
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
                        height: height * 0.04,
                      ),
                      TextFormField(
                        controller: passwordcontroller,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(
                                    color: AppColors.greenthemecolor,
                                    width: 3)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color: AppColors.greenthemecolor, width: 3),
                            ),
                            // helperText: 'Enter your password',
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
                    ],
                  )),
              SizedBox(
                height: height * 0.05375,
              ),
              RoundButton(
                loading: loading,
                title: 'SignUp',
                // ontap: () {
                //   if (_formfield.currentState!.validate()) {
                //       String referalId = "AYUS78907";
                //       setState(() {
                //         loading = true;
                //       });

                //       _auth
                //           .createUserWithEmailAndPassword(
                //         email: emailcontroller.text.toString(),
                //         password: passwordcontroller.text.toString(),
                //       )
                //           .then(
                //         (value) {
                //           String id = emailcontroller.text.toString();
                //           fireStore.doc(id).set({
                //             'Email': emailcontroller.text.toString(),
                //             'Password': passwordcontroller.text.toString(),
                //             'UID': DateTime.now()
                //                 .microsecondsSinceEpoch
                //                 .toString(),
                //             'My Courses': [],
                //             'DOJ': formattedDate,
                //             'Name': namecontroller.text.toString(),
                //             'Wallet': "0",
                //             'ReferalId': referalId
                //           }).then((value) {
                //             setState(
                //               () {
                //                 loading = false;
                //                 Utils().toastMessage(
                //                     'Account Sucessfully Created');
                //                 _auth // login succesful to then function mei chala jayega warna on error mei chala jayegaa
                //                     .signInWithEmailAndPassword(
                //                         email: emailcontroller.text.toString(),
                //                         password:
                //                             passwordcontroller.text.toString())
                //                     .then((value) {
                //                   fireStore2.doc(referalId).set({
                //                     "id": referalId,
                //                     "Email": emailcontroller.text.toString(),
                //                     "count": "0"
                //                   }).then(
                //                     (value) {
                //                       Utils().toastMessage('Login succesful');
                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                             builder: (context) => MainPage(),
                //                           ));
                //                     },
                //                   ).onError(
                //                     (error, stackTrace) {
                //                       Utils().toastMessage(error.toString());
                //                     },
                //                   );
                //                 });
                //               },
                //             );
                //           });
                //         },
                //       ).onError(
                //         (error, stackTrace) {
                //           Utils().toastMessage(error.toString());
                //           setState(() {
                //             loading = false;
                //           });
                //         },
                //       );
                //     // fireStore2
                //     //     .doc("AYUS78907")
                //     //     .get()
                //     //     .then((docSnapshot) async {
                //     //   if (docSnapshot.exists) {
                //     //     String referralEmail =
                //     //         docSnapshot.data()?['Email'] ?? 'Email not found';
                //     //     DocumentReference userDocRef = FirebaseFirestore
                //     //         .instance
                //     //         .collection('Users')
                //     //         .doc(docSnapshot.data()?['Email']);
                //     //     await userDocRef.update({
                //     //       'MyReferals': FieldValue.arrayUnion(
                //     //           [emailcontroller.text.toString()])
                //     //     });

                //     //     // Referral code exists, proceed with user creation

                //     //   } else {
                //     //     // Referral code not found
                //     //     Utils().toastMessage('Invalid referral code');
                //     //   }
                //     // }
                //    // );
                //   }
                // }
                onTap: () {
                  if (_formfield.currentState!.validate()) {
                    String enteredReferalCode =
                        referalcodecontroller.text.trim();
                    if (referalcodecontroller.text.isEmpty) {
                      if (_formfield.currentState!.validate()) {
                        String lastfour =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        int length = lastfour.length;
                        String referalId = namecontroller.text.substring(0, 4) +
                            DateTime.now()
                                .microsecondsSinceEpoch
                                .toString()
                                .substring(length - 4);

                        // namecontroller.text[3].toString() +
                        //     DateTime.now().microsecondsSinceEpoch.toString();
                        setState(() {
                          loading = true;
                        });

                        _auth
                            .createUserWithEmailAndPassword(
                          email: emailcontroller.text.toString(),
                          password: passwordcontroller.text.toString(),
                        )
                            .then(
                          (value) {
                            String id = emailcontroller.text.toString();
                            fireStore.doc(id).set({
                              'Email': emailcontroller.text.toString(),
                              'Password': passwordcontroller.text.toString(),
                              'UID': DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString(),
                              'My Courses': [],
                              'Favorites': [],
                              'DOJ': formattedDate,
                              'Name': namecontroller.text.toString(),
                              'Wallet': "0",
                              'ReferalId': referalId
                            }).then((value) {
                              setState(
                                () {
                                  loading = false;
                                  Utils().toastMessage(
                                      'Account Sucessfully Created');
                                  _auth // login succesful to then function mei chala jayega warna on error mei chala jayegaa
                                      .signInWithEmailAndPassword(
                                          email:
                                              emailcontroller.text.toString(),
                                          password: passwordcontroller.text
                                              .toString())
                                      .then((value) {
                                    fireStore2.doc(referalId).set({
                                      "id": referalId,
                                      "Email": emailcontroller.text.toString(),
                                      "count": "0"
                                    }).then(
                                      (value) {
                                        Utils().toastMessage('Login succesful');
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MainPage(),
                                            ));
                                      },
                                    ).onError(
                                      (error, stackTrace) {
                                        Utils().toastMessage(
                                            'Error While Creating Account Try Again');
                                      },
                                    );
                                  });
                                },
                              );
                            });
                          },
                        ).onError(
                          (error, stackTrace) {
                            Utils().toastMessage(
                                'Error While Creating Account Try Again');
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      }
                    } else {
                      fireStore2
                          .doc(enteredReferalCode)
                          .get()
                          .then((docSnapshot) {
                        if (docSnapshot.exists) {
                          // Referral code exists, proceed with user creation
                          createNewUser(formattedDate,
                              referalcodecontroller.text.toString());
                        } else {
                          // Referral code not found
                          Utils().toastMessage('Invalid referral code');
                        }
                      }).catchError((error) {
                        //   Utils().toastMessage(
                        //      'Error checking referral code: $error');
                      });
                    }
                  }
                },
              ),
              SizedBox(
                height: height * 0.0475,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Have An Account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: AppColors.greenthemecolor),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void createNewUser(String formatteddate, String enteredrefferedid) {
    String lastfour = DateTime.now().microsecondsSinceEpoch.toString();
    int length = lastfour.length;
    String referalId = namecontroller.text.substring(0, 4) +
        DateTime.now().microsecondsSinceEpoch.toString().substring(length - 4);
    setState(() {
      loading = true;
    });

    _auth
        .createUserWithEmailAndPassword(
      email: emailcontroller.text.toString(),
      password: passwordcontroller.text.toString(),
    )
        .then((value) {
      String id = emailcontroller.text.toString();
      fireStore.doc(id).set({
        'Email': emailcontroller.text.toString(),
        'Password': passwordcontroller.text.toString(),
        'UID': DateTime.now().microsecondsSinceEpoch.toString(),
        'My Courses': [],
        'DOJ': formatteddate,
        'Name': namecontroller.text.toString(),
        'Wallet': "0",
        'Favorites': [],
        'ReferalId': referalId
      }).then((value) {
        setState(() {
          loading = false;
          Utils().toastMessage('Account Sucessfully Created');
          _auth
              .signInWithEmailAndPassword(
                  email: emailcontroller.text.toString(),
                  password: passwordcontroller.text.toString())
              .then((value) {
            fireStore2.doc(referalId).set({
              "id": referalId,
              "Email": emailcontroller.text.toString(),
              "count": "0"
            }).then((value) {
              updateReferralCount(enteredrefferedid);
            }).onError((error, stackTrace) {
              Utils().toastMessage('Error While Creating Account Try Again');
            });
          });
        });
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage('Error While Creating Account Try Again');
      setState(() {
        loading = false;
      });
    });
  }

  void updateReferralCount(String referralCode) {
    fireStore2.doc(referralCode).get().then((docSnapshot) async {
      if (docSnapshot.exists) {
        DocumentReference userDocRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(docSnapshot.data()?['Email']);
        await userDocRef.update({
          'MyReferals': FieldValue.arrayUnion([emailcontroller.text.toString()])
        });
      }
    }).then(
      (value) {
        fireStore2.doc(referralCode).update({
          'count': FieldValue.increment(1),
        }).then((_) {
          //   Utils().toastMessage('Referral success');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
              ));
        }).catchError((error) {
          //    Utils().toastMessage('Error updating referral count: $error');
        });
      },
    );
  }
}
