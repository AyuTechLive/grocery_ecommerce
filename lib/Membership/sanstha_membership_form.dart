import 'package:flutter/material.dart';
import 'package:hakeekat_farmer_version/Membership/essentials/sansthadocumentupload.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MembershipForm extends StatefulWidget {
  @override
  _MembershipFormState createState() => _MembershipFormState();
}

class _MembershipFormState extends State<MembershipForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _uuid = Uuid();

  String? _submittedFormId;
  String? _formStatus;

  // Create controllers for each TextField
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _bhamashahController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _gramPanchayatController =
      TextEditingController();
  final TextEditingController _tehsilController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkExistingSubmission();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _nameController.dispose();
    _fatherNameController.dispose();
    _aadharController.dispose();
    _bhamashahController.dispose();
    _mobileController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _occupationController.dispose();
    _villageController.dispose();
    _cityController.dispose();
    _gramPanchayatController.dispose();
    _tehsilController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  Future<void> _checkExistingSubmission() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('SanastaApplication')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        setState(() {
          _submittedFormId = doc.id;
          _formStatus = doc['status'];
        });
        _loadFormData(doc);
      }
    }
  }

  void _loadFormData(DocumentSnapshot doc) {
    _nameController.text = doc['name'];
    _fatherNameController.text = doc['fatherName'];
    _aadharController.text = doc['aadharNumber'];
    _bhamashahController.text = doc['bhamashahNumber'];
    _mobileController.text = doc['mobileNumber'];
    _whatsappController.text = doc['whatsappNumber'];
    _emailController.text = doc['email'];
    _occupationController.text = doc['occupation'];
    _villageController.text = doc['village'];
    _cityController.text = doc['city'];
    _gramPanchayatController.text = doc['gramPanchayat'];
    _tehsilController.text = doc['tehsil'];
    _districtController.text = doc['district'];
    _stateController.text = doc['state'];
    _pinCodeController.text = doc['pinCode'];
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must be logged in to submit a form')),
        );
        return;
      }

      Map<String, dynamic> formData = {
        'name': _nameController.text,
        'fatherName': _fatherNameController.text,
        'aadharNumber': _aadharController.text,
        'bhamashahNumber': _bhamashahController.text,
        'mobileNumber': _mobileController.text,
        'whatsappNumber': _whatsappController.text,
        'email': user.email,
        'occupation': _occupationController.text,
        'village': _villageController.text,
        'city': _cityController.text,
        'gramPanchayat': _gramPanchayatController.text,
        'tehsil': _tehsilController.text,
        'district': _districtController.text,
        'state': _stateController.text,
        'pinCode': _pinCodeController.text,
        'submissionDate': FieldValue.serverTimestamp(),
        'status': 'pending',
      };

      // Navigate to SansthaDocumentUploadScreen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SansthaDocumentUploadScreen(formData: formData),
        ),
      );
    }
  }

  Future<void> _reapply() async {
    User? user = _auth.currentUser;
    if (user != null && _submittedFormId != null) {
      await _firestore
          .collection('SanastaApplication')
          .doc(_submittedFormId)
          .delete();
      setState(() {
        _submittedFormId = null;
        _formStatus = null;
      });
      _formKey.currentState!.reset();
    }
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('सदस्यता आवेदन पत्र',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _submittedFormId != null
                  ? _buildSubmittedFormView()
                  : _buildFormView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmittedFormView() {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Form Status: $_formStatus',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          if (_formStatus == 'accepted')
            _buildFormDetails()
          else if (_formStatus == 'rejected')
            ElevatedButton(
              child: Text('Apply Again'),
              onPressed: _reapply,
            )
          else
            Text(
                'Your application is being reviewed. Please check back later.'),
        ],
      ),
    );
  }

  Widget _buildFormDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem('Name', _nameController.text),
                  _buildDetailItem(
                      'Father\'s Name', _fatherNameController.text),
                  _buildDetailItem('Aadhar Number', _aadharController.text),
                  _buildDetailItem(
                      'Bhamashah Number', _bhamashahController.text),
                  _buildDetailItem('Mobile Number', _mobileController.text),
                  _buildDetailItem('WhatsApp Number', _whatsappController.text),
                  _buildDetailItem('Email', _emailController.text),
                  _buildDetailItem('Occupation', _occupationController.text),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 12),
                  _buildDetailItem('Village', _villageController.text),
                  _buildDetailItem('City', _cityController.text),
                  _buildDetailItem(
                      'Gram Panchayat', _gramPanchayatController.text),
                  _buildDetailItem('Tehsil', _tehsilController.text),
                  _buildDetailItem('District', _districtController.text),
                  _buildDetailItem('State', _stateController.text),
                  _buildDetailItem('Pin Code', _pinCodeController.text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField(
                          '1. आवेदक / संस्था का नाम', _nameController),
                      SizedBox(height: 16),
                      _buildTextField(
                          '2. पिता / पति का नाम', _fatherNameController),
                      SizedBox(height: 16),
                      _buildTextField('3. आधार कार्ड नम्बर', _aadharController),
                      SizedBox(height: 16),
                      _buildTextField(
                          '4. भामशाह कार्ड नम्बर', _bhamashahController),
                      SizedBox(height: 16),
                      _buildTextField('5. मोबाइल नं.', _mobileController),
                      SizedBox(height: 16),
                      _buildTextField(
                          '6. व्हाट्सएप मोबाइल नं.', _whatsappController),
                      SizedBox(height: 16),
                      _buildTextField('7. ई - मेल एड्रेस', _emailController),
                      SizedBox(height: 16),
                      _buildTextField('8. व्यवसाय', _occupationController),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('9. आवेदक / संस्था का पता:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 16),
                      _buildTextField('ग्राम / वार्ड', _villageController),
                      SizedBox(height: 12),
                      _buildTextField('पंचायत / शहर का नाम', _cityController),
                      SizedBox(height: 12),
                      _buildTextField(
                          'ग्राम पंचायत का नाम', _gramPanchayatController),
                      SizedBox(height: 12),
                      _buildTextField(
                          'पंचायत समिति / तहसील का नाम', _tehsilController),
                      SizedBox(height: 12),
                      _buildTextField('जिला', _districtController),
                      SizedBox(height: 12),
                      _buildTextField('राज्य', _stateController),
                      SizedBox(height: 12),
                      _buildTextField('पिन कोड नम्बर', _pinCodeController),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('दिनांक: ${DateTime.now().toString().split(' ')[0]}',
                      style: TextStyle(color: Colors.black)),
                  ElevatedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenthemecolor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.indigo.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.indigo.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.indigo.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.indigo, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
