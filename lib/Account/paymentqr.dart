import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class QrCode extends StatefulWidget {
  const QrCode({super.key});

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  final fireStore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> bonusData = [
    {'amount': 1000, 'bonus': 0},
    {'amount': 2000, 'bonus': 50},
    {'amount': 5000, 'bonus': 150},
    {'amount': 10000, 'bonus': 400},
    {'amount': 20000, 'bonus': 1200},
    {'amount': 50000, 'bonus': 4000},
  ];

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'QR Code',
              style: TextStyle(
                  color: AppColors.greenthemecolor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            FutureBuilder<String?>(
              future: getUIDFromFirestore('img'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      child: Image.network(
                        snapshot.data.toString(),
                        scale: 2,
                      ),
                    ),
                  );
                } else {
                  return Text('UID not found');
                }
              },
            ),
            SizedBox(height: height * 0.03),
            Text(
              'Bonus Table',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      TableCell(
                          child: Center(
                              child: Text('Amount',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      TableCell(
                          child: Center(
                              child: Text('Bonus',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                  ...bonusData
                      .map((data) => TableRow(
                            children: [
                              TableCell(
                                  child: Center(
                                      child: Text(data['amount'].toString()))),
                              TableCell(
                                  child: Center(
                                      child: Text(data['bonus'].toString()))),
                            ],
                          ))
                      .toList(),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            FutureBuilder<String?>(
              future: getUIDFromFirestore('bankdetails'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                        width: width * 0.9,
                        child: Text(
                          "Bank Details: " + snapshot.data.toString(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                  );
                } else {
                  return Text('UID not found');
                }
              },
            ),
            SizedBox(
              height: height * 0.03,
            ),
            FutureBuilder<String?>(
              future: getUIDFromFirestore('InfoText'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                        width: width * 0.9,
                        child: Text(
                          "*" + snapshot.data.toString(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                  );
                } else {
                  return Text('UID not found');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> getUIDFromFirestore(String key) async {
    try {
      DocumentSnapshot userDocSnapshot =
          await fireStore.collection('qr').doc('qrcode').get();

      if (userDocSnapshot.exists) {
        Map<String, dynamic>? userData =
            userDocSnapshot.data() as Map<String, dynamic>?;
        return userData?[key];
      }
    } catch (e) {
      print('Error occurred while retrieving UID: $e');
      return null;
    }
    return null;
  }
}
