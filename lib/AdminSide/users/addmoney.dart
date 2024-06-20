import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMoney extends StatefulWidget {
  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  String _searchQuery = '';
  bool _isSearching = false;

  Future<void> _updateWalletBalance(
      String userId, String amount, String bonus, bool isAdd) async {
    try {
      final userDoc = _usersCollection.doc(userId);
      final userData = await userDoc.get();

      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;
        String currentBalance = data['Wallet'] ?? '0';
        String currentBonus = data['Bonus'] ?? '0';
        double currentBalanceValue = double.parse(currentBalance);
        double currentBonusValue = double.parse(currentBonus);
        double amountValue = double.parse(amount);
        double bonusValue = double.parse(bonus);

        double newBalanceValue = isAdd
            ? currentBalanceValue + amountValue
            : currentBalanceValue - amountValue;
        double newBonusValue = currentBonusValue + bonusValue;

        String newBalance = newBalanceValue.toStringAsFixed(2);
        String newBonus = newBonusValue.toStringAsFixed(2);

        await userDoc.update({
          'Wallet': newBalance,
          'balance': newBonus,
        });

        await userDoc.collection('transactions').add({
          'amount': isAdd ? amountValue : -amountValue,
          'bonus': bonusValue,
          'type': isAdd ? 'Credit' : 'Debit',
          'date': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAdd
                ? 'Amount and bonus added to wallet successfully'
                : 'Amount removed and bonus added to wallet successfully'),
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

  void _showAmountDialog(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modify Wallet Balance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _bonusController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter bonus amount',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Add'),
              onPressed: () {
                final amount = _amountController.text;
                final bonus = _bonusController.text;
                if (amount.isNotEmpty && bonus.isNotEmpty) {
                  _updateWalletBalance(userId, amount, bonus, true);
                  Navigator.of(context).pop();
                  _amountController.clear();
                  _bonusController.clear();
                }
              },
            ),
            // TextButton(
            //   child: Text('Remove'),
            //   onPressed: () {
            //     final amount = _amountController.text;
            //     final bonus = _bonusController.text;
            //     if (amount.isNotEmpty && bonus.isNotEmpty) {
            //       _updateWalletBalance(userId, amount, bonus, false);
            //       Navigator.of(context).pop();
            //       _amountController.clear();
            //       _bonusController.clear();
            //     }
            //   },
            // ),
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search by Email or Name',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
      ),
      style: TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase();
        });
      },
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchController.text.isEmpty) {
              _stopSearch();
              return;
            }
            _searchController.clear();
            setState(() {
              _searchQuery = '';
            });
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text('Users'),
        actions: _buildActions(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;
          final filteredUsers = users.where((doc) {
            final userData = doc.data() as Map<String, dynamic>?;
            final userEmail = userData?['Email'] as String? ?? '';
            final userName = userData?['Name'] as String? ?? '';
            return userEmail.toLowerCase().contains(_searchQuery) ||
                userName.toLowerCase().contains(_searchQuery);
          }).toList();

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index].data() as Map<String, dynamic>?;
              final userId = filteredUsers[index].id;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?['Name'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Email: ${user?['Email'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Wallet Balance: ₹${user?['Wallet'] ?? '0'}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: Text('Modify Balance'),
                              onPressed: () => _showAmountDialog(userId),
                              style: ElevatedButton.styleFrom(
                                //primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
