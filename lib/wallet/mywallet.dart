import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/wallet/component/walletcomponent.dart';
import 'package:intl/intl.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet>
    with SingleTickerProviderStateMixin {
  String? _userBalance;
  String? _userUid;
  String? _name;
  late TabController _tabController;
  String? email;

  @override
  void initState() {
    super.initState();
    email = checkUserAuthenticationType();
    _tabController =
        TabController(length: 2, vsync: this); // Initialize _tabController
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final String email = checkUserAuthenticationType();
    final userDocSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();

    if (userDocSnapshot.exists) {
      final userData = userDocSnapshot.data();
      final balance = userData?['Wallet'] ?? 0;
      final uid = userData?['UID'] ?? '';
      final name = userData?['Name'] ?? '';
      setState(() {
        _userBalance = balance.toString();
        _userUid = uid;
        _name = name;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of _tabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        bottom: TabBar(
          controller: _tabController, // Use _tabController
          tabs: const [
            Tab(text: 'Credit'),
            Tab(text: 'Debit'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.02,
          ),
          Center(
            child: WalletComponent(
              balance: _userBalance.toString(),
              uid: _userUid.toString(),
              reward: '',
              name: _name.toString(),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Row(
            children: [
              SizedBox(
                width: width * 0.04,
              ),
              Text(
                'Transaction History:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController, // Use _tabController
              children: [
                _buildTransactionList(true),
                _buildTransactionList(false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(bool isCredit) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .collection('transactions')
          .where('type', isEqualTo: isCredit ? 'Credit' : 'Debit')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final transactions = snapshot.data!.docs;

        return ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              height: height * 0.02,
            );
          },
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction =
                transactions[index].data() as Map<String, dynamic>?;
            final amount = transaction?['amount'] ?? 0.0;
            final date = transaction?['date'] as Timestamp?;
            final formattedDate = date != null
                ? DateFormat('dd/MM/yyyy hh:mm a').format(date.toDate())
                : '';

            return Padding(
              padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
              child: Container(
                width: width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.2))),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Id: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              Text(' ${transactions[index].id}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Date:',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text('  ${formattedDate}')
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        amount.toString(),
                        style: TextStyle(
                            color: isCredit ? Colors.green : Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      )
                    ],
                  ),
                ),
              ),
            );

            // ListTile(
            //   title: Text('Amount: $amount'),
            //   subtitle: Text('Date: $formattedDate'),
            // );
          },
        );
      },
    );
  }
}
