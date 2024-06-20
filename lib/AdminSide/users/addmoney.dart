import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMoney extends StatefulWidget {
  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  final TextEditingController _amountController = TextEditingController();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<void> _updateWalletBalance(
      String userId, String amount, bool isAdd) async {
    try {
      final userDoc = _usersCollection.doc(userId);
      final userData = await userDoc.get();

      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;
        String currentBalance = data['Wallet'] ?? '0';
        double currentBalanceValue = double.parse(currentBalance);
        double amountValue = double.parse(amount);
        double newBalanceValue = isAdd
            ? currentBalanceValue + amountValue
            : currentBalanceValue - amountValue;
        String newBalance = newBalanceValue.toStringAsFixed(2);

        await userDoc.update({'Wallet': newBalance});

        // Store the transaction details in the user's subcollection
        await userDoc.collection('transactions').add({
          'amount': isAdd ? amountValue : -amountValue,
          'type': isAdd ? 'Credit' : 'Debit',
          'date': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAdd
                ? 'Amount added to wallet successfully'
                : 'Amount removed from wallet successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersCollection.snapshots(),
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

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>?;
              final userId = users[index].id;

              return ListTile(
                title: Text(user?['Name'] ?? 'Unknown'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wallet Balance: ${user?['Wallet'] ?? '0'}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Amount',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final amount = _amountController.text;
                        if (amount.isNotEmpty) {
                          _updateWalletBalance(userId, amount, true);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        final amount = _amountController.text;
                        if (amount.isNotEmpty) {
                          _updateWalletBalance(userId, amount, false);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
