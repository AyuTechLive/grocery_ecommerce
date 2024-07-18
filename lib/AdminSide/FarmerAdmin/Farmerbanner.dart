import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hakikat_app_new/AdminSide/addbanner.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/utils.dart';

class FarmerBanner extends StatefulWidget {
  const FarmerBanner({Key? key}) : super(key: key);

  @override
  State<FarmerBanner> createState() => _FarmerBannerState();
}

class _FarmerBannerState extends State<FarmerBanner> {
  final fireStore =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'))
          .collection('Banners')
          .snapshots();
  final CollectionReference ref =
      FirebaseFirestore.instanceFor(app: Firebase.app('secondary'))
          .collection('Banners');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banners'),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: _buildBannerList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddBanner())),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Add Banner', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.greenthemecolor,
      ),
    );
  }

  Widget _buildBannerList() {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No banners found'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            return _buildBannerCard(doc);
          },
        );
      },
    );
  }

  Widget _buildBannerCard(QueryDocumentSnapshot doc) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              doc['Banner Image Link'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey[300],
                child: Icon(Icons.error, size: 50, color: Colors.grey[600]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    doc['Banner Title'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(doc),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(QueryDocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Banner"),
          content: Text("Are you sure you want to delete this banner?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref.doc(doc.id).delete().then((_) {
                  Utils().toastMessage('Banner deleted successfully');
                  Navigator.of(context).pop();
                }).catchError((error) {
                  Utils().toastMessage('Failed to delete banner: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }
}
