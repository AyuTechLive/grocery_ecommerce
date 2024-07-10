import 'package:flutter/material.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FarmerMembershipForm extends StatefulWidget {
  @override
  _FarmerMembershipFormState createState() => _FarmerMembershipFormState();
}

class _FarmerMembershipFormState extends State<FarmerMembershipForm> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _uuid = Uuid();

  // Form fields
  final TextEditingController _membershipNumberController =
      TextEditingController();
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String docId = _uuid.v4();
      try {
        await _firestore.collection('FarmerOrganicApplication').doc(docId).set({
          'id': docId,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully')),
        );
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
        title: Text('कुदरती/जैविक खेती करने हेतु आवेदन पत्र',
            style: TextStyle(color: Colors.white)),
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
                _buildCard([
                  _buildTextField(
                      '1. सदस्यता क्रमांक', _membershipNumberController),
                  _buildTextField(
                      '2. I. कुल भूमि (बीघा)', _totalLandController),
                  CheckboxListTile(
                    title: Text(
                        'II. क्या आप पूर्व से ही कुदरती/जैविक खेती कर रहे हैं?'),
                    value: isAlreadyDoingOrganicFarming,
                    onChanged: (bool? value) {
                      setState(() {
                        isAlreadyDoingOrganicFarming = value ?? false;
                      });
                    },
                  ),
                  if (isAlreadyDoingOrganicFarming) ...[
                    _buildTextField('a) यदि हां तो कब से',
                        _organicFarmingStartDateController),
                    _buildTextField(
                        'कितनी भूमि में (बीघा)', _organicFarmingLandController),
                    Text(
                        'b) पूर्व में आप द्वारा कौन कौन सी फसलें ली जाती रही हैं?'),
                    for (int i = 0; i < 4; i++)
                      _buildTextField(
                          'फसल ${i + 1}', _previousCropsControllers[i]),
                  ],
                  if (!isAlreadyDoingOrganicFarming)
                    _buildTextField(
                        'III. यदि नहीं तो भूमि का क्षेत्रफल जिसमें कुदरती/जैविक खेती करनी है (बीघा)',
                        _nonOrganicLandController),
                  _buildTextField(
                      'IV. कुदरती/जैविक खेती कब से करनी है (खरीफ/रबी)',
                      _organicFarmingStartSeasonController),
                ]),
                SizedBox(height: 24),
                _buildCard([
                  Text(
                      'V. कुदरती/जैविक खेती की जाने वाली भूमि का विस्तृत विवरण:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  for (int i = 0; i < 3; i++)
                    _buildTextField('किला नंबर/मुरब्बा/खसरा नंबर ${i + 1}',
                        _khasraNumbersControllers[i]),
                  _buildTextField('(4) चक/ग्राम का नाम (जहां खेत स्थित है)',
                      _villageLocationController),
                  _buildTextField('(5) पंचायत समिति/तहसील का नाम',
                      _panchayatNameController),
                  _buildTextField('(7) राज्य', _stateController),
                  _buildTextField('(9) जिला मुख्यालय से दूरी (km)',
                      _districtHeadquartersDistanceController),
                ]),
                SizedBox(height: 24),
                _buildCard([
                  Text('3. पशुधन का विवरण',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  for (String animal in livestockControllers.keys)
                    _buildTextField(animal, livestockControllers[animal]!),
                  CheckboxListTile(
                    title:
                        Text('4. क्या आप कुदरती दुग्ध विक्रय करना चाहते हैं?'),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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
      ),
    );
  }
}
