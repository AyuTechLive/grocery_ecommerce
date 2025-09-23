import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool loading = false;
  bool isImageUploading = false;
  final postController = TextEditingController();
  late TextEditingController categoryNameController;
  final productTitleController = TextEditingController();
  final mapController = TextEditingController();
  final productPriceController = TextEditingController();
  final productSubtitleController = TextEditingController();
  final productDiscriptionController = TextEditingController();
  final productQuantityController = TextEditingController();
  final matchImgController = TextEditingController();
  bool isExclusive = false;
  bool isBestSelling = false;

  late DatabaseReference databaseRef;
  late FirebaseStorage storage;
  String? selectedCourse;
  List<String> courses = [];

  // Cross-platform image handling
  List<File> _images = [];
  List<Uint8List> _webImages = [];
  List<String> _imageUrls = [];

  final picker = ImagePicker();

  Future<void> getImageGallery() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      if (kIsWeb) {
        List<Uint8List> webImages = [];
        for (var pickedFile in pickedFiles) {
          final bytes = await pickedFile.readAsBytes();
          webImages.add(bytes);
        }
        setState(() {
          _webImages.addAll(webImages);
        });
      } else {
        setState(() {
          _images
              .addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
        });
      }
    }
  }

  Future<void> handleImageUpload() async {
    if (_images.isNotEmpty || _webImages.isNotEmpty) {
      try {
        setState(() {
          isImageUploading = true;
        });

        List<String> uploadedUrls = [];

        if (kIsWeb) {
          for (int i = 0; i < _webImages.length; i++) {
            String url = await uploadWebImage(_webImages[i], i);
            uploadedUrls.add(url);
          }
        } else {
          uploadedUrls = await Future.wait(_images.map(uploadimage));
        }

        setState(() {
          _imageUrls.addAll(uploadedUrls);
        });
      } catch (e) {
        Utils().toastMessage('Failed to upload images: $e');
      } finally {
        setState(() {
          isImageUploading = false;
        });
      }
    } else {
      Utils().toastMessage('No images selected');
    }
  }

  @override
  void initState() {
    fetchCourses();
    categoryNameController = TextEditingController();
    storage = FirebaseStorage.instance;
    super.initState();
  }

  void removeImage(int index) {
    setState(() {
      if (kIsWeb) {
        if (index < _webImages.length) {
          _webImages.removeAt(index);
        }
      } else {
        if (index < _images.length) {
          _images.removeAt(index);
        }
      }
    });
  }

  void fetchCourses() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('Categories').get();
    for (var doc in querySnapshot.docs) {
      var categoryName = doc['Category Name'];
      courses.add(categoryName);
    }
    setState(() {});
  }

  Widget _buildImagePreview(int index) {
    if (kIsWeb && index < _webImages.length) {
      return Image.memory(
        _webImages[index],
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (!kIsWeb && index < _images.length) {
      return Image.file(
        _images[index],
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;
    final bool isWeb = kIsWeb;
    final double maxWidth = isWeb ? 800 : double.infinity;
    final double horizontalPadding = isWeb ? 40.0 : 20.0;
    final int totalImages = kIsWeb ? _webImages.length : _images.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
        centerTitle: isWeb,
      ),
      body: Center(
        child: Container(
          width: maxWidth,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  SizedBox(height: height * 0.02),

                  // Category Dropdown
                  _buildCategoryDropdown(),
                  SizedBox(height: height * 0.02),

                  // Product Form Fields
                  if (isWeb) ...[
                    // Web layout - two columns
                    Row(
                      children: [
                        Expanded(
                            child: _buildTextField(
                                productTitleController, 'Product Title')),
                        SizedBox(width: 16),
                        Expanded(
                            child: _buildTextField(
                                productSubtitleController, 'Subtitle')),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Expanded(
                            child: _buildTextField(
                                productPriceController, 'Price')),
                        SizedBox(width: 16),
                        Expanded(
                            child: _buildTextField(
                                productQuantityController, 'Quantity')),
                      ],
                    ),
                  ] else ...[
                    // Mobile layout - single column
                    _buildTextField(productTitleController, 'Product Title'),
                    SizedBox(height: height * 0.02),
                    _buildTextField(productSubtitleController, 'Subtitle'),
                    SizedBox(height: height * 0.02),
                    _buildTextField(productPriceController, 'Price'),
                    SizedBox(height: height * 0.02),
                    _buildTextField(productQuantityController, 'Quantity'),
                  ],

                  SizedBox(height: height * 0.02),

                  // Description
                  _buildTextField(
                      productDiscriptionController, 'Product Description',
                      maxLines: 4),
                  SizedBox(height: height * 0.02),

                  // Image Gallery Section
                  _buildImageGallerySection(width, height, totalImages),

                  // Product Options
                  _buildProductOptions(),

                  SizedBox(height: 30),

                  // Add Product Button
                  SizedBox(
                    width: double.infinity,
                    child: RoundButton(
                      loading: loading || isImageUploading,
                      title: 'Add Product',
                      onTap: _addProduct,
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xff001C65), width: 3),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      child: Row(
        children: [
          Icon(Icons.category, color: Color(0xff001C65)),
          SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: selectedCourse,
                hint: Text('Select Category'),
                items: courses.map((String course) {
                  return DropdownMenuItem<String>(
                    value: course,
                    child: Text(course),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCourse = newValue;
                    categoryNameController.text = selectedCourse ?? '';
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.greenthemecolor, width: 2),
        ),
      ),
    );
  }

  Widget _buildImageGallerySection(
      double width, double height, int totalImages) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_library, color: AppColors.greenthemecolor),
              SizedBox(width: 8),
              Text(
                'Product Images',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              if (isImageUploading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: kIsWeb ? height * 0.3 : height * 0.25,
            child: ListView.builder(
              itemCount: totalImages + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == totalImages) {
                  return _buildAddImageButton(width, height);
                }
                return _buildImageCard(index, width, height);
              },
            ),
          ),
          if (totalImages > 0) ...[
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  '$totalImages image(s) selected',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Spacer(),
                if (!isImageUploading)
                  TextButton.icon(
                    onPressed: handleImageUpload,
                    icon: Icon(Icons.cloud_upload, size: 16),
                    label: Text('Upload All'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.greenthemecolor,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddImageButton(double width, double height) {
    return Container(
      width: kIsWeb ? width * 0.25 : width * 0.3,
      margin: EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: getImageGallery,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Colors.grey[400]!, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate,
                  size: 40, color: Colors.grey[600]),
              SizedBox(height: 8),
              Text(
                'Add Images',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(int index, double width, double height) {
    return Container(
      width: kIsWeb ? width * 0.25 : width * 0.4,
      margin: EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImagePreview(index),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => removeImage(index),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductOptions() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Options',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          SwitchListTile(
            title: Text('Exclusive Product'),
            subtitle: Text('Mark as exclusive item'),
            value: isExclusive,
            onChanged: (value) {
              setState(() {
                isExclusive = value;
              });
            },
            activeColor: AppColors.greenthemecolor,
          ),
          SwitchListTile(
            title: Text('Best Selling'),
            subtitle: Text('Mark as best seller'),
            value: isBestSelling,
            onChanged: (value) {
              setState(() {
                isBestSelling = value;
              });
            },
            activeColor: AppColors.greenthemecolor,
          ),
        ],
      ),
    );
  }

  void _addProduct() async {
    if (isImageUploading) {
      Utils().toastMessage('Please wait for image upload to complete');
      return;
    }

    if (selectedCourse == null ||
        productTitleController.text.isEmpty ||
        productSubtitleController.text.isEmpty ||
        productDiscriptionController.text.isEmpty ||
        productPriceController.text.isEmpty ||
        productQuantityController.text.isEmpty) {
      Utils().toastMessage('Please fill all required fields');
      return;
    }

    if (_imageUrls.isEmpty) {
      Utils().toastMessage('Please upload at least one product image');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      String idnew = DateTime.now().millisecondsSinceEpoch.toString();
      databaseRef = FirebaseDatabase.instance.ref();

      await databaseRef.child(idnew).set({
        'id': idnew,
        'Product Title': productTitleController.text.toString(),
        'Product Img': _imageUrls,
        'Product Subtitle': productSubtitleController.text.toString(),
        'Product Discription': productDiscriptionController.text.toString(),
        'Product Price': productPriceController.text.toString(),
        'Product Stock': productQuantityController.text.toString(),
        'Category': categoryNameController.text.toString(),
        'Exclusive': isExclusive,
        'BestSelling': isBestSelling,
        'CreatedAt': DateTime.now().toIso8601String(),
      });

      Utils().toastMessage('Product Successfully Added');
      Navigator.pop(context);
    } catch (error) {
      Utils().toastMessage('Failed to add product: $error');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<String> uploadimage(File imageFile) async {
    String fileExtension = imageFile.path.split('.').last;
    String fileName = '${DateTime.now().microsecondsSinceEpoch}.$fileExtension';
    firebase_storage.Reference ref = storage.ref('/products/$fileName');
    firebase_storage.SettableMetadata metadata =
        firebase_storage.SettableMetadata(
      contentType: 'image/$fileExtension',
      contentDisposition: 'inline; filename="$fileName"',
    );
    firebase_storage.UploadTask uploadTask = ref.putFile(imageFile, metadata);
    await uploadTask;
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadWebImage(Uint8List imageBytes, int index) async {
    String fileName = '${DateTime.now().microsecondsSinceEpoch}_$index.jpg';
    firebase_storage.Reference ref = storage.ref('/products/$fileName');
    firebase_storage.SettableMetadata metadata =
        firebase_storage.SettableMetadata(
      contentType: 'image/jpeg',
      contentDisposition: 'inline; filename="$fileName"',
    );
    firebase_storage.UploadTask uploadTask = ref.putData(imageBytes, metadata);
    await uploadTask;
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
}
