import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/wallet/component/walletcomponent.dart';

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

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction =
                transactions[index].data() as Map<String, dynamic>?;
            final amount = transaction?['amount'] ?? 0.0;
            final date = transaction?['date'] as Timestamp?;
            final formattedDate = date != null ? date.toDate().toString() : '';

            return ListTile(
              title: Text('Amount: $amount'),
              subtitle: Text('Date: $formattedDate'),
            );
          },
        );
      },
    );
  }
}
