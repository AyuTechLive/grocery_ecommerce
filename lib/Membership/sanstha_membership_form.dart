import 'package:flutter/material.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class MembershipForm extends StatefulWidget {
  @override
  _MembershipFormState createState() => _MembershipFormState();
}

class _MembershipFormState extends State<MembershipForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _uuid = Uuid();

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String docId = _uuid.v4(); // Generate a unique ID for the document
      try {
        await _firestore.collection('SanastaApplication').doc(docId).set({
          'id': docId,
          'name': _nameController.text,
          'fatherName': _fatherNameController.text,
          'aadharNumber': _aadharController.text,
          'bhamashahNumber': _bhamashahController.text,
          'mobileNumber': _mobileController.text,
          'whatsappNumber': _whatsappController.text,
          'email': _emailController.text,
          'occupation': _occupationController.text,
          'village': _villageController.text,
          'city': _cityController.text,
          'gramPanchayat': _gramPanchayatController.text,
          'tehsil': _tehsilController.text,
          'district': _districtController.text,
          'state': _stateController.text,
          'pinCode': _pinCodeController.text,
          'submissionDate': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully')),
        );
        // Clear the form after successful submission
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting form: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('सदस्यता आवेदन पत्र', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.greenthemecolor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.greenthemecolor, Colors.green.shade200],
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
                        _buildTextField(
                            '3. आधार कार्ड नम्बर', _aadharController),
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
                        style: TextStyle(color: Colors.white)),
                    ElevatedButton(
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
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
