import 'package:flutter/material.dart';

class MembershipApplicationForm extends StatefulWidget {
  @override
  _MembershipApplicationFormState createState() =>
      _MembershipApplicationFormState();
}

class _MembershipApplicationFormState extends State<MembershipApplicationForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String? applicantName;
  String? fatherName;
  String? aadharNumber;
  String? bhamashaNumber;
  String? mobileNumber;
  String? whatsappNumber;
  String? email;
  String? occupation;
  String? address;
  String? village;
  String? panchayat;
  String? gramPanchayat;
  String? tehsil;
  String? district;
  String? state;
  String? pinCode;
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('सदस्यता आवेदन पत्र'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'आवेदक / संस्था का नाम'),
                onSaved: (value) => applicantName = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'पिता / पति का नाम'),
                onSaved: (value) => fatherName = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'आधार कार्ड नम्बर'),
                onSaved: (value) => aadharNumber = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'भामशाह कार्ड नम्बर'),
                onSaved: (value) => bhamashaNumber = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'मोबाइल नं.'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => mobileNumber = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'व्हाट्सएप मोबाइल नं.'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => whatsappNumber = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ई - मेल एड्रेस'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => email = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'व्यवसाय'),
                onSaved: (value) => occupation = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'आवेदक / संस्था का पता'),
                onSaved: (value) => address = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ग्राम / वार्ड'),
                onSaved: (value) => village = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'पंचायत / शहर का नाम'),
                onSaved: (value) => panchayat = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ग्राम पंचायत का नाम'),
                onSaved: (value) => gramPanchayat = value,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'पंचायत समिति / तहसील का नाम'),
                onSaved: (value) => tehsil = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'जिला'),
                onSaved: (value) => district = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'राज्य'),
                onSaved: (value) => state = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'पिन कोड नम्बर'),
                keyboardType: TextInputType.number,
                onSaved: (value) => pinCode = value,
              ),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Process the form data
                    // You can print the values or send them to an API
                    print('Form submitted');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
