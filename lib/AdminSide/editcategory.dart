import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class EditCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String initialCategoryName;
  final String initialCategoryImageUrl;

  const EditCategoryScreen({
    super.key,
    required this.categoryId,
    required this.initialCategoryName,
    required this.initialCategoryImageUrl,
  });

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('Categories');

  late TextEditingController _categoryNameController;
  File? _categoryImage;
  String _categoryImageUrl = '';

  bool _loading = false;
  bool isdeleting = false;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _categoryNameController =
        TextEditingController(text: widget.initialCategoryName);
    _categoryImageUrl = widget.initialCategoryImageUrl;
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: AppColors.greenthemecolor,
        title: Text('Edit Category'),
        // actions: [
        //   IconButton(
        //     onPressed: _showDeleteConfirmationDialog,
        //     icon: Icon(Icons.delete, color: Colors.red),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _categoryNameController,
              maxLines: 1,
              decoration: InputDecoration(
                label: Text('Category Name'),
                hintText: 'Category Name',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            SizedBox(height: height * 0.02),
            // TextFormField(
            //   controller: _categoryNameController,
            //   decoration: InputDecoration(
            //     labelText: 'Category Name',
            //   ),
            // ),
            Text('Tap On Image To Change It'),
            SizedBox(
              height: height * 0.02,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[300],
                ),
                child: _categoryImage != null
                    ? Image.file(
                        _categoryImage!,
                        fit: BoxFit.cover,
                      )
                    : _categoryImageUrl.isNotEmpty
                        ? Image.network(
                            _categoryImageUrl,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text('Click to pick an image'),
                          ),
              ),
            ),
            SizedBox(height: height * 0.04),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(AppColors.greenthemecolor)),
              onPressed: _updateCategory,
              child: _loading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Update Category',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            ElevatedButton(
              onPressed: _showDeleteConfirmationDialog,
              child: isdeleting
                  ? CircularProgressIndicator()
                  : Text('Delete Category'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _categoryImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileExtension = imageFile.path.split('.').last;
    String fileName = '${DateTime.now().microsecondsSinceEpoch}.$fileExtension';
    Reference ref = _storage.ref('/categories/$fileName');
    SettableMetadata metadata = SettableMetadata(
      contentType: 'image/$fileExtension',
      contentDisposition: 'inline; filename="$fileName"',
    );
    UploadTask uploadTask = ref.putFile(imageFile, metadata);
    await uploadTask;
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> _updateCategory() async {
    setState(() {
      _loading = true;
    });

    try {
      String categoryImageUrl = _categoryImageUrl;
      if (_categoryImage != null) {
        categoryImageUrl = await _uploadImage(_categoryImage!);
      }

      await _categoriesCollection.doc(widget.categoryId).update({
        'Category Name': _categoryNameController.text,
        'Category Img': categoryImageUrl,
      });
      Utils().toastMessage('Category updated successfully');
      Navigator.pop(context);
    } catch (e) {
      Utils().toastMessage('Failed to update category: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _deleteCategory,
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory() async {
    try {
      setState(() {
        isdeleting = true;
      });
      await _categoriesCollection.doc(widget.categoryId).delete();
      setState(() {
        isdeleting = false;
      });
      Utils().toastMessage('Category deleted successfully');
      Navigator.pop(context); // Navigate back after deleting the category
    } catch (e) {
      Utils().toastMessage('Failed to delete category: $e');
    }
  }
}
