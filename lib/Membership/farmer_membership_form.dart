import 'package:flutter/material.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FarmerMembershipForm extends StatefulWidget {
  @override
  _FarmerMembershipFormState createState() => _FarmerMembershipFormState();
}

class _FarmerMembershipFormState extends State<FarmerMembershipForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _uuid = Uuid();

  String? _submittedFormId;
  String? _formStatus;

  // Form fields
  late final TextEditingController _membershipNumberController;
  final TextEditingController _totalLandController = TextEditingController();
  final TextEditingController _organicFarmingStartDateController =
      TextEditingController();
  final TextEditingController _organicFarmingLandController =
      TextEditingController();
  final List<TextEditingController> _previousCropsControllers =
      List.generate(4, (_) => TextEditingController());
  final TextEditingController _nonOrganicLandController =
      TextEditingController();
  final TextEditingController _organicFarmingStartSeasonController =
      TextEditingController();
  final List<TextEditingController> _khasraNumbersControllers =
      List.generate(3, (_) => TextEditingController());
  final TextEditingController _villageLocationController =
      TextEditingController();
  final TextEditingController _panchayatNameController =
      TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtHeadquartersDistanceController =
      TextEditingController();

  bool isAlreadyDoingOrganicFarming = false;
  Map<String, TextEditingController> livestockControllers = {
    'Cow': TextEditingController(),
    'Buffalo': TextEditingController(),
    'Goat': TextEditingController(),
    'Sheep': TextEditingController(),
    'Other': TextEditingController(),
  };
  bool wantToSellMilk = false;
  final TextEditingController _milkQuantityController = TextEditingController();
  bool makeOrganicFertilizer = false;

  @override
  void initState() {
    super.initState();
    _membershipNumberController = TextEditingController(
      text: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _checkExistingSubmission();
  }

  @override
  void dispose() {
    // Dispose all controllers
    _membershipNumberController.dispose();
    _totalLandController.dispose();
    _organicFarmingStartDateController.dispose();
    _organicFarmingLandController.dispose();
    _previousCropsControllers.forEach((controller) => controller.dispose());
    _nonOrganicLandController.dispose();
    _organicFarmingStartSeasonController.dispose();
    _khasraNumbersControllers.forEach((controller) => controller.dispose());
    _villageLocationController.dispose();
    _panchayatNameController.dispose();
    _stateController.dispose();
    _districtHeadquartersDistanceController.dispose();
    livestockControllers.values.forEach((controller) => controller.dispose());
    _milkQuantityController.dispose();
    super.dispose();
  }

  Future<void> _checkExistingSubmission() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('FarmerOrganicApplication')
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
    _membershipNumberController.text = doc['membershipNumber'];
    _totalLandController.text = doc['totalLand'].toString();
    isAlreadyDoingOrganicFarming = doc['isAlreadyDoingOrganicFarming'];
    _organicFarmingStartDateController.text = doc['organicFarmingStartDate'];
    _organicFarmingLandController.text = doc['organicFarmingLand'].toString();
    for (int i = 0; i < 4; i++) {
      _previousCropsControllers[i].text = doc['previousCrops'][i] ?? '';
    }
    _nonOrganicLandController.text = doc['nonOrganicLand'].toString();
    _organicFarmingStartSeasonController.text =
        doc['organicFarmingStartSeason'];
    for (int i = 0; i < 3; i++) {
      _khasraNumbersControllers[i].text = doc['khasraNumbers'][i] ?? '';
    }
    _villageLocationController.text = doc['villageLocation'];
    _panchayatNameController.text = doc['panchayatName'];
    _stateController.text = doc['state'];
    _districtHeadquartersDistanceController.text =
        doc['districtHeadquartersDistance'];
    doc['livestock'].forEach((key, value) {
      livestockControllers[key]?.text = value.toString();
    });
    wantToSellMilk = doc['wantToSellMilk'];
    _milkQuantityController.text = doc['milkQuantity'].toString();
    makeOrganicFertilizer = doc['makeOrganicFertilizer'];
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

      String docId = _uuid.v4();
      try {
        await _firestore.collection('FarmerOrganicApplication').doc(docId).set({
          'id': docId,
          'email': user.email,
          'status': 'pending',
          'membershipNumber': _membershipNumberController.text,
          'totalLand': double.tryParse(_totalLandController.text),
          'isAlreadyDoingOrganicFarming': isAlreadyDoingOrganicFarming,
          'organicFarmingStartDate': _organicFarmingStartDateController.text,
          'organicFarmingLand':
              double.tryParse(_organicFarmingLandController.text),
          'previousCrops':
              _previousCropsControllers.map((e) => e.text).toList(),
          'nonOrganicLand': double.tryParse(_nonOrganicLandController.text),
          'organicFarmingStartSeason':
              _organicFarmingStartSeasonController.text,
          'khasraNumbers':
              _khasraNumbersControllers.map((e) => e.text).toList(),
          'villageLocation': _villageLocationController.text,
          'panchayatName': _panchayatNameController.text,
          'state': _stateController.text,
          'districtHeadquartersDistance':
              _districtHeadquartersDistanceController.text,
          'livestock': livestockControllers.map(
              (key, value) => MapEntry(key, int.tryParse(value.text) ?? 0)),
          'wantToSellMilk': wantToSellMilk,
          'milkQuantity': double.tryParse(_milkQuantityController.text),
          'makeOrganicFertilizer': makeOrganicFertilizer,
          'submissionDate': FieldValue.serverTimestamp(),
        });
        setState(() {
          _submittedFormId = docId;
          _formStatus = 'pending';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting form: $e')),
        );
      }
    }
  }

  Future<void> _reapply() async {
    User? user = _auth.currentUser;
    if (user != null && _submittedFormId != null) {
      await _firestore
          .collection('FarmerOrganicApplication')
          .doc(_submittedFormId)
          .delete();
      setState(() {
        _submittedFormId = null;
        _formStatus = null;
      });
      _formKey.currentState!.reset();
      _membershipNumberController.text =
          DateTime.now().millisecondsSinceEpoch.toString();
    }
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('कुदरती/जैविक खेती करने हेतु आवेदन पत्र',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _submittedFormId != null
                    ? _buildSubmittedFormView()
                    : _buildFormView(),
              ],
            ),
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
          _buildDetailItem(
              'Membership Number', _membershipNumberController.text),
          _buildDetailItem('Total Land', _totalLandController.text),
          _buildDetailItem('Already Doing Organic Farming',
              isAlreadyDoingOrganicFarming.toString()),
          _buildDetailItem('Organic Farming Start Date',
              _organicFarmingStartDateController.text),
          _buildDetailItem(
              'Organic Farming Land', _organicFarmingLandController.text),
          for (int i = 0; i < 4; i++)
            _buildDetailItem(
                'Previous Crop ${i + 1}', _previousCropsControllers[i].text),
          _buildDetailItem('Non-Organic Land', _nonOrganicLandController.text),
          _buildDetailItem('Organic Farming Start Season',
              _organicFarmingStartSeasonController.text),
          for (int i = 0; i < 3; i++)
            _buildDetailItem(
                'Khasra Number ${i + 1}', _khasraNumbersControllers[i].text),
          _buildDetailItem('Village Location', _villageLocationController.text),
          _buildDetailItem('Panchayat Name', _panchayatNameController.text),
          _buildDetailItem('State', _stateController.text),
          _buildDetailItem('District Headquarters Distance',
              _districtHeadquartersDistanceController.text),
          for (String animal in livestockControllers.keys)
            _buildDetailItem(animal, livestockControllers[animal]!.text),
          _buildDetailItem('Want to Sell Milk', wantToSellMilk.toString()),
          _buildDetailItem('Milk Quantity', _milkQuantityController.text),
          _buildDetailItem(
              'Make Organic Fertilizer', makeOrganicFertilizer.toString()),
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCard([
            _buildTextField('1. सदस्यता क्रमांक', _membershipNumberController,
                enabled: false),
            _buildTextField('2. I. कुल भूमि (बीघा)', _totalLandController),
            CheckboxListTile(
              title:
                  Text('II. क्या आप पूर्व से ही कुदरती/जैविक खेती कर रहे हैं?'),
              value: isAlreadyDoingOrganicFarming,
              onChanged: (bool? value) {
                setState(() {
                  isAlreadyDoingOrganicFarming = value ?? false;
                });
              },
            ),
            if (isAlreadyDoingOrganicFarming) ...[
              _buildTextField(
                  'a) यदि हां तो कब से', _organicFarmingStartDateController),
              _buildTextField(
                  'कितनी भूमि में (बीघा)', _organicFarmingLandController),
              Text('b) पूर्व में आप द्वारा कौन कौन सी फसलें ली जाती रही हैं?'),
              for (int i = 0; i < 4; i++)
                _buildTextField('फसल ${i + 1}', _previousCropsControllers[i]),
            ],
            if (!isAlreadyDoingOrganicFarming)
              _buildTextField(
                  'III. यदि नहीं तो भूमि का क्षेत्रफल जिसमें कुदरती/जैविक खेती करनी है (बीघा)',
                  _nonOrganicLandController),
            _buildTextField('IV. कुदरती/जैविक खेती कब से करनी है (खरीफ/रबी)',
                _organicFarmingStartSeasonController),
          ]),
          SizedBox(height: 24),
          _buildCard([
            Text('V. कुदरती/जैविक खेती की जाने वाली भूमि का विस्तृत विवरण:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            for (int i = 0; i < 3; i++)
              _buildTextField('किला नंबर/मुरब्बा/खसरा नंबर ${i + 1}',
                  _khasraNumbersControllers[i]),
            _buildTextField('(4) चक/ग्राम का नाम (जहां खेत स्थित है)',
                _villageLocationController),
            _buildTextField(
                '(5) पंचायत समिति/तहसील का नाम', _panchayatNameController),
            _buildTextField('(7) राज्य', _stateController),
            _buildTextField('(9) जिला मुख्यालय से दूरी (km)',
                _districtHeadquartersDistanceController),
          ]),
          SizedBox(height: 24),
          _buildCard([
            Text('3. पशुधन का विवरण',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            for (String animal in livestockControllers.keys)
              _buildTextField(animal, livestockControllers[animal]!),
            CheckboxListTile(
              title: Text('4. क्या आप कुदरती दुग्ध विक्रय करना चाहते हैं?'),
              value: wantToSellMilk,
              onChanged: (bool? value) {
                setState(() {
                  wantToSellMilk = value ?? false;
                });
              },
            ),
            if (wantToSellMilk)
              _buildTextField(
                  '5. यदि हां तो दुग्ध किसका है गाय/भैंस/बकरी आदि - दुग्ध की मात्रा (लीटर)',
                  _milkQuantityController),
            CheckboxListTile(
              title: Text(
                  '6. क्या आप जैविक उर्वरक/कीटनाशक(खाद/बीजामृत/जीवामृत/अन्य) आप स्वयं तैयार करते हैं?'),
              value: makeOrganicFertilizer,
              onChanged: (bool? value) {
                setState(() {
                  makeOrganicFertilizer = value ?? false;
                });
              },
            ),
          ]),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('दिनांक: ${DateTime.now().toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.black)),
              ElevatedButton(
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenthemecolor,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
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
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
