import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMoney extends StatefulWidget {
  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarkcontroller = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  String _searchQuery = '';
  bool _isSearching = false;

  final int _pageSize = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;
  List<DocumentSnapshot> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!_hasMoreData || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    Query query = _usersCollection.orderBy('Email').limit(_pageSize);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.length < _pageSize) {
      _hasMoreData = false;
    }

    _users.addAll(snapshot.docs);

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateWalletBalance(String userId, String amount, String bonus,
      bool isAdd, String remark) async {
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
        double newBonusValue = bonusValue;

        String newBalance = newBalanceValue.toStringAsFixed(2);
        String newBonus = newBonusValue.toStringAsFixed(2);

        await userDoc.update({
          'Wallet': newBalance,
          'Bonus': newBonus,
        });

        await userDoc.collection('transactions').add({
          'amount': isAdd ? amountValue : -amountValue,
          'bonus': bonusValue,
          'type': isAdd ? 'Credit' : 'Debit',
          'date': DateTime.now(),
          'remarks': remark
        });

        // Check for referral bonus
        if (isAdd && amountValue >= 1000) {
          int referralCounter = data['ReferralCounter'] ?? 0;
          if (referralCounter == 0 && data['ReferredBy'] != null) {
            String referrerEmail = data['ReferredBy'];
            await _addReferralBonus(referrerEmail);

            // Update referral counter to 1
            await userDoc.update({'ReferralCounter': 1});
          }
        }

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

  Future<void> _addReferralBonus(String referrerEmail) async {
    try {
      QuerySnapshot referrerQuery =
          await _usersCollection.where('Email', isEqualTo: referrerEmail).get();

      if (referrerQuery.docs.isNotEmpty) {
        DocumentSnapshot referrerDoc = referrerQuery.docs.first;
        String referrerId = referrerDoc.id;
        Map<String, dynamic> referrerData =
            referrerDoc.data() as Map<String, dynamic>;

        double currentWallet = double.parse(referrerData['Wallet'] ?? '0');
        double currentBonus = double.parse(referrerData['Bonus'] ?? '0');

        double newWallet = currentWallet + 20;
        double newBonus = currentBonus + 20;

        await _usersCollection.doc(referrerId).update({
          'Wallet': newWallet.toStringAsFixed(2),
          'Bonus': newBonus.toStringAsFixed(2),
        });

        await _usersCollection.doc(referrerId).collection('transactions').add({
          'amount': 20,
          'bonus': 20,
          'type': 'Credit',
          'date': DateTime.now(),
          'remarks': 'Referral bonus'
        });
      }
    } catch (e) {
      print('Error adding referral bonus: $e');
    }
  }

  void _showAmountDialog(String userId) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                  TextField(
                    controller: _remarkcontroller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter remarks',
                    ),
                  ),
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Add'),
                  onPressed: isLoading
                      ? null
                      : () async {
                          final amount = _amountController.text;
                          final bonus = _bonusController.text;
                          final remark = _remarkcontroller.text;
                          if (amount.isNotEmpty && bonus.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            await _updateWalletBalance(
                                userId, amount, bonus, true, remark);
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context).pop();
                            _amountController.clear();
                            _bonusController.clear();
                            _remarkcontroller.clear();
                            _reloadData();
                          }
                        },
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed:
                      isLoading ? null : () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _reloadData() {
    setState(() {
      _users.clear();
      _lastDocument = null;
      _hasMoreData = true;
    });
    _fetchData();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
      _users.clear();
      _lastDocument = null;
      _hasMoreData = true;
      _fetchData();
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
      _users.clear();
      _lastDocument = null;
      _hasMoreData = true;
      _fetchData();
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
          _users.clear();
          _lastDocument = null;
          _hasMoreData = true;
          _fetchData();
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
      body: ListView.builder(
        itemCount: _users.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _users.length) {
            if (!_isLoading) {
              _fetchData();
            }
            return Center(child: CircularProgressIndicator());
          }

          final user = _users[index].data() as Map<String, dynamic>?;
          final userId = _users[index].id;

          // Only show users that match the search query
          final userEmail = user?['Email'] as String? ?? '';
          final userName = user?['Name'] as String? ?? '';
          if (_searchQuery.isNotEmpty &&
              !userEmail.toLowerCase().contains(_searchQuery) &&
              !userName.toLowerCase().contains(_searchQuery)) {
            return SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bonus Balance: ₹${user?['Bonus'] ?? '0'}',
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
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _searchController.dispose();
    _bonusController.dispose();
    _remarkcontroller.dispose();
    super.dispose();
  }
}
