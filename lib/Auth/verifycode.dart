// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:oneup_noobs/Pages/homepage.dart';
// import 'package:oneup_noobs/Utils/utils.dart';
// import 'package:oneup_noobs/minorcomponents/roundbutton.dart';

// class VerifyCode extends StatefulWidget {
//   final String verificationId;
//   final String mobno;
//   final String name;
//   const VerifyCode(
//       {super.key,
//       required this.verificationId,
//       required this.mobno,
//       required this.name});

//   @override
//   State<VerifyCode> createState() => _VerifyCodeState();
// }

// class _VerifyCodeState extends State<VerifyCode> {
//   final TextEditingController _pin1Controller = TextEditingController();
//   final TextEditingController _pin2Controller = TextEditingController();
//   final TextEditingController _pin3Controller = TextEditingController();
//   final TextEditingController _pin4Controller = TextEditingController();
//   final TextEditingController _pin5Controller = TextEditingController();
//   final TextEditingController _pin6Controller = TextEditingController();

//   String fullPin = '';
//   bool loading = false;
//   final auth = FirebaseAuth.instance;
//   final fireStore = FirebaseFirestore.instance.collection('Users');
//   final verifyCodeController = TextEditingController();
//   @override
//   void dispose() {
//     _pin1Controller.dispose();
//     _pin2Controller.dispose();
//     _pin3Controller.dispose();
//     _pin4Controller.dispose();
//     _pin5Controller.dispose();
//     _pin6Controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size screensize = MediaQuery.of(context).size;
//     final double height = screensize.height;
//     final double width = screensize.width;
//     DateTime currentDate = DateTime.now();
//     String formattedDate =
//         '${currentDate.day}-${currentDate.month}-${currentDate.year}';
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Form(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Spacer(),
//                   SizedBox(
//                     height: height * 0.085,
//                     width: width * 0.15,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         hintText: '0',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(20),
//                             ),
//                             borderSide:
//                                 BorderSide(color: Color(0xFFF17306), width: 3)),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           borderSide:
//                               BorderSide(color: Color(0xFFF17306), width: 3),
//                         ),
//                         //helperText: 'Enter your email',
//                       ),
//                       controller: _pin1Controller,
//                       onChanged: (value) =>
//                           _handlePinChange(value, _pin1Controller),
//                       style: Theme.of(context).textTheme.headline6,
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   SizedBox(
//                     height: height * 0.085,
//                     width: width * 0.15,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         hintText: '0',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(20),
//                             ),
//                             borderSide:
//                                 BorderSide(color: Color(0xFFF17306), width: 3)),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           borderSide:
//                               BorderSide(color: Color(0xFFF17306), width: 3),
//                         ),
//                         //helperText: 'Enter your email',
//                       ),
//                       controller: _pin2Controller,
//                       onChanged: (value) =>
//                           _handlePinChange(value, _pin2Controller),
//                       style: Theme.of(context).textTheme.headline6,
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   SizedBox(
//                     height: height * 0.085,
//                     width: width * 0.15,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         hintText: '0',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(20),
//                             ),
//                             borderSide:
//                                 BorderSide(color: Color(0xFFF17306), width: 3)),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           borderSide:
//                               BorderSide(color: Color(0xFFF17306), width: 3),
//                         ),
//                         //helperText: 'Enter your email',
//                       ),
//                       controller: _pin3Controller,
//                       onChanged: (value) =>
//                           _handlePinChange(value, _pin3Controller),
//                       style: Theme.of(context).textTheme.headline6,
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   SizedBox(
//                     height: height * 0.085,
//                     width: width * 0.15,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         hintText: '0',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(20),
//                             ),
//                             borderSide:
//                                 BorderSide(color: Color(0xFFF17306), width: 3)),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           borderSide:
//                               BorderSide(color: Color(0xFFF17306), width: 3),
//                         ),
//                         //helperText: 'Enter your email',
//                       ),
//                       controller: _pin4Controller,
//                       onChanged: (value) =>
//                           _handlePinChange(value, _pin4Controller),
//                       style: Theme.of(context).textTheme.headline6,
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   SizedBox(
//                     height: height * 0.085,
//                     width: width * 0.15,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         hintText: '0',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(20),
//                             ),
//                             borderSide:
//                                 BorderSide(color: Color(0xFFF17306), width: 3)),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           borderSide:
//                               BorderSide(color: Color(0xFFF17306), width: 3),
//                         ),
//                         //helperText: 'Enter your email',
//                       ),
//                       controller: _pin5Controller,
//                       onChanged: (value) =>
//                           _handlePinChange(value, _pin5Controller),
//                       style: Theme.of(context).textTheme.headline6,
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   SizedBox(
//                     height: height * 0.085,
//                     width: width * 0.15,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         hintText: '0',
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(20),
//                             ),
//                             borderSide:
//                                 BorderSide(color: Color(0xFFF17306), width: 3)),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           borderSide:
//                               BorderSide(color: Color(0xFFF17306), width: 3),
//                         ),
//                         //helperText: 'Enter your email',
//                       ),
//                       controller: _pin6Controller,
//                       onChanged: (value) =>
//                           _handlePinChange(value, _pin6Controller),
//                       style: Theme.of(context).textTheme.headline6,
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(1),
//                         FilteringTextInputFormatter.digitsOnly
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // TextFormField(
//             //   keyboardType: TextInputType.number,
//             //   controller: verifyCodeController,
//             //   decoration: InputDecoration(hintText: '6 Digit Code'),
//             // ),
//             // SizedBox(
//             //   height: 80,
//             // ),
//             SizedBox(
//               height: height * 0.05,
//             ),
//             Roundbuttonnew(
//                 loading: loading,
//                 title: 'Verify',
//                 ontap: () async {
//                   _saveFullPin();
//                   setState(() {
//                     loading = true;
//                   });
//                   final credential = PhoneAuthProvider.credential(
//                       verificationId: widget.verificationId, smsCode: fullPin);
//                   try {
//                     await auth.signInWithCredential(credential).then(
//                       (value) async {
//                         String id = widget.mobno;
//                         DocumentReference userDocRef = fireStore.doc(id);
//                         DocumentSnapshot userDocSnapshot =
//                             await userDocRef.get();
//                         if (!userDocSnapshot.exists) {
//                           // Document does not exist, so create it with the given data.
//                           await userDocRef.set({
//                             'Email': widget.mobno,
//                             'Password': 'mobilenologin',
//                             'UID': DateTime.now()
//                                 .microsecondsSinceEpoch
//                                 .toString(),
//                             'My Courses': [],
//                             'DOJ': formattedDate,
//                             'Name': widget.name
//                           });
//                         } else {
//                           Utils().toastMessage('Welcome Back');
//                           // Document already exists, handle this case if needed.
//                           // You could log this information, update only specific fields, or take some other action.
//                         }
//                       },
//                     );
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HomePage(),
//                         ));
//                   } catch (e) {
//                     setState(() {
//                       loading = false;
//                     });
//                     Utils().toastMessage(e.toString());
//                   }
//                 }),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handlePinChange(String value, TextEditingController controller) {
//     if (value.length == 1) {
//       FocusScope.of(context).nextFocus();
//     }
//     if (value.isEmpty) {
//       FocusScope.of(context).previousFocus();
//     }
//     if (value.isNotEmpty) {
//       if (controller == _pin1Controller) {
//         _pin1Controller.text = value;
//       } else if (controller == _pin2Controller) {
//         _pin2Controller.text = value;
//       } else if (controller == _pin3Controller) {
//         _pin3Controller.text = value;
//       } else if (controller == _pin4Controller) {
//         _pin4Controller.text = value;
//       } else if (controller == _pin5Controller) {
//         _pin5Controller.text = value;
//       } else if (controller == _pin6Controller) {
//         _pin6Controller.text = value;
//       }
//     }
//   }

//   void _saveFullPin() {
//     setState(() {
//       fullPin =
//           '${_pin1Controller.text}${_pin2Controller.text}${_pin3Controller.text}${_pin4Controller.text}${_pin5Controller.text}${_pin6Controller.text}';
//       // Use the fullPin variable where you need it
//       print('Full Pin: $fullPin');
//     });
//   }
// }
