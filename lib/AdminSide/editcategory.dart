import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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
  Uint8List? _webCategoryImage;
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

  Widget _buildImageContainer() {
    if (kIsWeb && _webCategoryImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.memory(
          _webCategoryImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else if (!kIsWeb && _categoryImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.file(
          _categoryImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else if (_categoryImageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          _categoryImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 50, color: Colors.grey),
                  Text('Failed to load image'),
                ],
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text('Click to pick an image'),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    final bool isWeb = kIsWeb;
    final double maxWidth = isWeb ? 600 : double.infinity;
    final double horizontalPadding = isWeb ? 40.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category'),
        centerTitle: isWeb,
        backgroundColor: isWeb ? AppColors.greenthemecolor : null,
        foregroundColor: isWeb ? Colors.white : null,
      ),
      body: Center(
        child: Container(
          width: maxWidth,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.03),

                  // Category Name Section
                  Card(
                    elevation: isWeb ? 4 : 1,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.greenthemecolor,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _categoryNameController,
                            decoration: InputDecoration(
                              labelText: 'Category Name',
                              hintText: 'Enter category name',
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.greenthemecolor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  // Image Section
                  Card(
                    elevation: isWeb ? 4 : 1,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.image,
                                  color: AppColors.greenthemecolor),
                              SizedBox(width: 8),
                              Text(
                                'Category Image',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.greenthemecolor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap on the image to change it',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: isWeb ? height * 0.3 : height * 0.25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: AppColors.greenthemecolor
                                      .withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: isWeb
                                    ? [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: _buildImageContainer(),
                            ),
                          ),
                          if (_categoryImage != null ||
                              _webCategoryImage != null) ...[
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.green, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'New image selected',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: isWeb
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: _buildUpdateButton(),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 200,
                    child: _buildDeleteButton(),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _buildUpdateButton()),
                  SizedBox(width: 16),
                  Expanded(child: _buildDeleteButton()),
                ],
              ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.greenthemecolor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: _loading ? null : _updateCategory,
      icon: _loading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Icon(Icons.update),
      label: Text(_loading ? 'Updating...' : 'Update Category'),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed:
          (isdeleting || _loading) ? null : _showDeleteConfirmationDialog,
      icon: isdeleting
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Icon(Icons.delete),
      label: Text(isdeleting ? 'Deleting...' : 'Delete Category'),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webCategoryImage = bytes;
          _categoryImage = null;
        });
      } else {
        setState(() {
          _categoryImage = File(pickedFile.path);
          _webCategoryImage = null;
        });
      }
    }
  }

  Future<String> _uploadImage() async {
    if (_categoryImage == null && _webCategoryImage == null) {
      throw Exception('No image file selected');
    }

    String fileName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
    Reference ref = _storage.ref('/categories/$fileName');
    SettableMetadata metadata = SettableMetadata(
      contentType: 'image/jpeg',
      contentDisposition: 'inline; filename="$fileName"',
    );

    UploadTask uploadTask;

    if (kIsWeb) {
      uploadTask = ref.putData(_webCategoryImage!, metadata);
    } else {
      uploadTask = ref.putFile(_categoryImage!, metadata);
    }

    await uploadTask;
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> _updateCategory() async {
    if (_categoryNameController.text.trim().isEmpty) {
      Utils().toastMessage('Please enter a category name');
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      String categoryImageUrl = _categoryImageUrl;

      // Upload new image if one was selected
      if (_categoryImage != null || _webCategoryImage != null) {
        categoryImageUrl = await _uploadImage();
      }

      await _categoriesCollection.doc(widget.categoryId).update({
        'Category Name': _categoryNameController.text.trim(),
        'Category Img': categoryImageUrl,
        'UpdatedAt': DateTime.now().toIso8601String(),
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
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete Category'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete this category?'),
              SizedBox(height: 8),
              Text(
                'Category: ${widget.initialCategoryName}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _deleteCategory();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory() async {
    setState(() {
      isdeleting = true;
    });

    try {
      await _categoriesCollection.doc(widget.categoryId).delete();
      Utils().toastMessage('Category deleted successfully');
      Navigator.pop(context);
    } catch (e) {
      Utils().toastMessage('Failed to delete category: $e');
    } finally {
      setState(() {
        isdeleting = false;
      });
    }
  }
}
