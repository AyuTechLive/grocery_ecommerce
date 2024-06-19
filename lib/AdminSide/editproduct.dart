import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hakikat_app_new/Utils/utils.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> initialProductData;
  final List<String> imageUrls;

  const EditProductScreen({
    super.key,
    required this.productId,
    required this.initialProductData,
    required this.imageUrls,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  List<int> _imagesToDelete = [];
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  bool _isExclusive = false;
  bool _isBestSelling = false;
  List<String> _updatedImageUrls = [];
  bool isdeleting = false;
  bool isuploading = false;
  List<File> _newImages = [];

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.initialProductData['Product Title'] ?? '');
    _subtitleController = TextEditingController(
        text: widget.initialProductData['Product Subtitle'] ?? '');
    _priceController = TextEditingController(
        text: widget.initialProductData['Product Price'] ?? '');
    _quantityController = TextEditingController(
        text: widget.initialProductData['Product Stock'] ?? '');
    _isExclusive = widget.initialProductData['Exclusive'] ?? false;
    _isBestSelling = widget.initialProductData['BestSelling'] ?? false;
    _updatedImageUrls = widget.imageUrls;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _deleteProduct() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel button
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isdeleting = true;
                });
                // Delete the product from the database
                await _databaseRef.child(widget.productId).remove();

                Utils().toastMessage('Product deleted successfully');
                Navigator.pop(context);
                setState(() {
                  isdeleting = false;
                }); // Close the dialog
                Navigator.pop(context); // Navigate back to the previous screen
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: _titleController,
                maxLines: 1,
                decoration: InputDecoration(
                  label: Text('Product Title'),
                  hintText: 'Product Title',
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

              TextFormField(
                controller: _subtitleController,
                maxLines: 1,
                decoration: InputDecoration(
                  label: Text('Subtitle'),
                  hintText: 'Subtitle',
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
              TextFormField(
                controller: _priceController,
                maxLines: 1,
                decoration: InputDecoration(
                  label: Text('Price'),
                  hintText: 'Price',
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
              TextFormField(
                controller: _quantityController,
                maxLines: 1,
                decoration: InputDecoration(
                  label: Text('Quantity'),
                  hintText: 'Quantity',
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
              SwitchListTile(
                title: Text('Exclusive'),
                value: _isExclusive,
                onChanged: (value) {
                  setState(() {
                    _isExclusive = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Best Selling'),
                value: _isBestSelling,
                onChanged: (value) {
                  setState(() {
                    _isBestSelling = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Images'),
              SizedBox(
                height: height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _updatedImageUrls.length +
                      _newImages.length -
                      _imagesToDelete.length +
                      1,
                  itemBuilder: (context, index) {
                    int actualIndex = index;
                    if (index ==
                        _updatedImageUrls.length +
                            _newImages.length -
                            _imagesToDelete.length) {
                      return IconButton(
                        onPressed: _pickImages,
                        icon: Container(
                          width: width * 0.3,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Icon(Icons.add),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: width * 0.27,
                                      child: Center(child: Text('Add More '))),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    for (int i = 0; i < _imagesToDelete.length; i++) {
                      if (_imagesToDelete[i] <= actualIndex) {
                        actualIndex++;
                      } else {
                        break;
                      }
                    }

                    if (actualIndex < _updatedImageUrls.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Stack(
                          children: [
                            Container(
                              width: width * 0.4,
                              height: height * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      _updatedImageUrls[actualIndex]),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _imagesToDelete.add(actualIndex);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final fileIndex = actualIndex - _updatedImageUrls.length;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Stack(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(_newImages[fileIndex]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _imagesToDelete.add(
                                        _updatedImageUrls.length + fileIndex);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: _updateProductDetails,
              //   child: Text('Update'),
              // ),
            ],
          ),
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
              onPressed: _updateProductDetails,
              child: isuploading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Update Product',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            ElevatedButton(
              onPressed: _deleteProduct,
              child: isdeleting
                  ? CircularProgressIndicator()
                  : Text('Delete Product'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _newImages
            .addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileExtension = imageFile.path.split('.').last;
    String fileName = '${DateTime.now().microsecondsSinceEpoch}.$fileExtension';
    Reference ref = _storage.ref('/foldername/$fileName');
    SettableMetadata metadata = SettableMetadata(
      contentType: 'image/$fileExtension',
      contentDisposition: 'inline; filename="$fileName"',
    );
    UploadTask uploadTask = ref.putFile(imageFile, metadata);
    await uploadTask;
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> _updateProductDetails() async {
    setState(() {
      isuploading = true;
    });
    // Remove images marked for deletion
    _updatedImageUrls.removeWhere(
        (url) => _imagesToDelete.contains(_updatedImageUrls.indexOf(url)));
    _newImages.removeWhere((file) => _imagesToDelete
        .contains(_updatedImageUrls.length + _newImages.indexOf(file)));

    List<String> updatedImageUrls = await Future.wait(
        _newImages.map((imageFile) => _uploadImage(imageFile)));
    _updatedImageUrls.addAll(updatedImageUrls);

    Map<String, dynamic> updatedData = {
      'Product Title': _titleController.text,
      'Product Subtitle': _subtitleController.text,
      'Product Price': _priceController.text,
      'Product Stock': _quantityController.text,
      'Exclusive': _isExclusive,
      'BestSelling': _isBestSelling,
      'Product Img': _updatedImageUrls,
    };

    _databaseRef.child(widget.productId).update(updatedData).then((_) {
      setState(() {
        isuploading = false;
      });
      Utils().toastMessage('Product details updated successfully');
      Navigator.pop(context);
    }).catchError((error) {
      Utils().toastMessage('Failed to update product details: $error');
    });
  }
}
