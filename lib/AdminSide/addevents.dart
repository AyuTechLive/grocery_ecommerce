import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Home/mainpage.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/roundbutton.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:hakikat_app_new/Utils/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  bool loading = false;
  bool isImageUploading = false;
  final hostnamecontroller = TextEditingController();
  final eventnamecontroller = TextEditingController();
  final timecontroller = TextEditingController();
  final eventimgcontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final dobcontroller = TextEditingController();
  final eventdetailcontroller = TextEditingController();
  final CollectionReference eventcollection =
      FirebaseFirestore.instance.collection('events');

  File? _image;
  Uint8List? _webImage;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();

  Future<void> getimageGallery() async {
    final pickedfile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedfile != null) {
      if (kIsWeb) {
        final bytes = await pickedfile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _image = null;
        });
      } else {
        setState(() {
          _image = File(pickedfile.path);
          _webImage = null;
        });
      }
    }
  }

  Future<void> handleImageUpload() async {
    if (_image != null || _webImage != null) {
      try {
        setState(() {
          isImageUploading = true;
        });
        String imageUrl = await uploadimage();
        eventimgcontroller.text = imageUrl;
      } catch (e) {
        Utils().toastMessage('Failed to upload image: $e');
      } finally {
        setState(() {
          isImageUploading = false;
        });
      }
    } else {
      Utils().toastMessage('No image selected');
    }
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _webImage != null) {
      return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: MemoryImage(_webImage!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (!kIsWeb && _image != null) {
      return Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: FileImage(_image!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    final bool isWeb = kIsWeb;
    final double maxWidth = isWeb ? 700 : double.infinity;
    final double horizontalPadding = isWeb ? 40.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Events'),
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
                  SizedBox(height: height * 0.03),

                  // Event Name
                  _buildTextField(
                    controller: eventnamecontroller,
                    hintText: 'Event Name',
                    icon: Icons.event,
                  ),
                  SizedBox(height: height * 0.03),

                  // Host Name
                  _buildTextField(
                    controller: hostnamecontroller,
                    hintText: 'Host Name',
                    icon: Icons.person,
                  ),
                  SizedBox(height: height * 0.03),

                  // Event Details
                  _buildTextField(
                    controller: eventdetailcontroller,
                    hintText: 'Event Details',
                    icon: Icons.description,
                    maxLines: 5,
                  ),
                  SizedBox(height: height * 0.03),

                  // Time and Date Row for Web
                  if (isWeb) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: timecontroller,
                            hintText: 'Time',
                            icon: Icons.access_time,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: datecontroller,
                            hintText: 'Date',
                            icon: Icons.calendar_today,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Time
                    _buildTextField(
                      controller: timecontroller,
                      hintText: 'Time',
                      icon: Icons.access_time,
                    ),
                    SizedBox(height: height * 0.03),

                    // Date
                    _buildTextField(
                      controller: datecontroller,
                      hintText: 'Date',
                      icon: Icons.calendar_today,
                    ),
                  ],

                  SizedBox(height: height * 0.03),

                  // Image Picker Section
                  _buildImagePickerSection(),

                  SizedBox(height: height * 0.03),

                  // Add Event Button
                  SizedBox(
                    width: double.infinity,
                    child: RoundButton(
                      loading: loading || isImageUploading,
                      title: 'Add Event',
                      onTap: _addEvent,
                    ),
                  ),

                  SizedBox(height: height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
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

  Widget _buildImagePickerSection() {
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
              Icon(Icons.add_a_photo, color: AppColors.greenthemecolor),
              SizedBox(width: 8),
              Text(
                'Event Image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          if (_image != null || _webImage != null) ...[
            _buildImagePreview(),
            SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: eventimgcontroller,
                  readOnly: true,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Image URL will appear here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  await getimageGallery();
                  if (_image != null || _webImage != null) {
                    await handleImageUpload();
                  }
                },
                icon: Icon(Icons.upload),
                label: Text('Upload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenthemecolor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addEvent() async {
    if (isImageUploading) {
      Utils().toastMessage('Please wait for image upload to complete');
      return;
    }

    if (eventnamecontroller.text.isEmpty ||
        hostnamecontroller.text.isEmpty ||
        timecontroller.text.isEmpty ||
        datecontroller.text.isEmpty ||
        eventdetailcontroller.text.isEmpty ||
        eventimgcontroller.text.isEmpty) {
      Utils().toastMessage('Please fill all fields');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await addeventdetails(
        eventnamecontroller.text.toString(),
        hostnamecontroller.text.toString(),
        timecontroller.text.toString(),
        eventimgcontroller.text.toString(),
        datecontroller.text.toString(),
        eventdetailcontroller.text.toString(),
      );

      Utils().toastMessage('Event Successfully Added');
      nextScreenReplace(context, MainPage());
    } catch (error) {
      Utils().toastMessage(error.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<String> uploadimage() async {
    if (_image == null && _webImage == null) {
      throw Exception('No image file selected');
    }

    String fileName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
    firebase_storage.Reference ref = storage.ref('/events/$fileName');
    firebase_storage.SettableMetadata metadata =
        firebase_storage.SettableMetadata(
      contentType: 'image/jpeg',
      contentDisposition: 'inline; filename="$fileName"',
    );

    firebase_storage.UploadTask uploadTask;

    if (kIsWeb) {
      uploadTask = ref.putData(_webImage!, metadata);
    } else {
      uploadTask = ref.putFile(_image!, metadata);
    }

    await uploadTask;
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future addeventdetails(String eventname, String hostname, String time,
      String eventbannerimg, String eventdate, String eventdetails) async {
    var date = DateTime.now().microsecondsSinceEpoch.toString();
    await eventcollection.doc(date).set({
      'BannerImg': eventbannerimg,
      'EventName': eventname,
      'Time': time,
      'HostName': hostname,
      'EventDate': eventdate,
      'Event Details': eventdetails,
      'id': date,
    });
  }
}
