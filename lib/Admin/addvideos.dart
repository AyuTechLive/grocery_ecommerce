import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hakeekat_farmer_version/Utils/roundbutton.dart';
import 'package:hakeekat_farmer_version/Utils/utils.dart';

class AddLecturesAdmin extends StatefulWidget {
  const AddLecturesAdmin({super.key});

  @override
  State<AddLecturesAdmin> createState() => _AddLecturesAdminState();
}

class _AddLecturesAdminState extends State<AddLecturesAdmin> {
  bool loading = false;
  final postcontroller = TextEditingController();
  late TextEditingController cousenamecontroller;
  final subjectcontroller = TextEditingController();
  final videotitlecontroller = TextEditingController();
  final videosubtitlecontroller = TextEditingController();
  final videourlcontroller = TextEditingController();
  final videolectureno = TextEditingController();
  late DatabaseReference databaseRef;
  String? selectedCourse;
  String? selectedSubject;
  List<String> courses = [];
  List<String> subjects = [];
  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState

    cousenamecontroller = TextEditingController();
    fetchCourses();
  }

  void fetchCourses() async {
    // Fetch courses from Firestore and update the local list
    var querySnapshot =
        await FirebaseFirestore.instance.collection('All Courses').get();
    for (var doc in querySnapshot.docs) {
      courses.add(doc.id); // Assuming you use document IDs as course names
    }
    // If required, update the state to reflect the changes in the UI
    setState(() {});
  }

  void fetchSubjects(String courseName) async {
    // Assuming the courseName is the key for the subjects in the Realtime Database
    databaseRef = FirebaseDatabase.instance.ref(courseName).child('SUBJECTS');
    DatabaseEvent event = await databaseRef.once();

    Map<dynamic, dynamic> subjectsData =
        event.snapshot.value as Map<dynamic, dynamic>;
    subjects.clear(); // Clear previous subjects
    subjectsData.forEach((key, value) {
      subjects.add(key); // Assuming the key is the subject name
    });
    setState(() {
      selectedSubject = null; // Reset the selected subject when course changes
    });
  }

  @override
  Widget build(BuildContext context) {
    String action = 'Videos';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff321f73),
        foregroundColor: Colors.white,
        title: Text('Add Your Course Content'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              // DropdownButtonFormField<String>(
              //   value: selectedCourse,
              //   hint: Text('Select Course'),
              //   items: courses.map((String course) {
              //     return DropdownMenuItem<String>(
              //       value: course,
              //       child: Text(course),
              //     );
              //   }).toList(),
              //   onChanged: (newValue) {
              //     // Update the selected course state
              //     setState(() {
              //       selectedCourse = newValue;
              //       cousenamecontroller.text = selectedCourse ?? '';
              //       if (selectedCourse != null) {
              //         fetchSubjects(selectedCourse!);
              //       }
              //     });
              //   },
              // ),
              // // TextFormField(
              // //   controller: cousenamecontroller,
              // //   maxLines: 1,
              // //   decoration: InputDecoration(
              // //       hintText: 'Enter the course name',
              // //       border: OutlineInputBorder()),
              // // ),
              // if (selectedCourse != null) ...[
              //   SizedBox(height: 20),
              //   DropdownButtonFormField<String>(
              //     value: selectedSubject,
              //     hint: Text('Select Subject'),
              //     items: subjects.map((String subject) {
              //       return DropdownMenuItem<String>(
              //         value: subject,
              //         child: Text(subject),
              //       );
              //     }).toList(),
              //     onChanged: (newValue) {
              //       setState(() {
              //         selectedSubject = newValue;
              //         subjectcontroller.text = selectedSubject ?? '';
              //       });
              //     },
              //   ),
              //  ],
              TextFormField(
                controller: subjectcontroller,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Enter Your Subject',
                    border: OutlineInputBorder()),
              ),
              TextFormField(
                controller: videolectureno,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Lecture name', border: OutlineInputBorder()),
              ),
              TextFormField(
                controller: videotitlecontroller,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Enter Your VideoTitle',
                    border: OutlineInputBorder()),
              ),
              TextFormField(
                controller: videosubtitlecontroller,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Enter Your VideoSubtitle',
                    border: OutlineInputBorder()),
              ),
              TextFormField(
                controller: videourlcontroller,
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: 'Enter Your videourl',
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              RoundButton(
                loading: loading,
                title: 'Add Video Lecture',
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef = FirebaseDatabase.instance.ref();
                  databaseRef.child(id).set({
                    'id': id,
                    'Title': videotitlecontroller.text.toString(),
                    'Subtitle': videosubtitlecontroller.text.toString(),
                    'Video Link': videourlcontroller.text.toString()
                  }).then(
                    (value) {
                      Utils().toastMessage('Post Succesfully Added');
                      setState(() {
                        counter++;
                        loading = false;
                        subjectcontroller.clear();
                        videotitlecontroller.clear();
                        videosubtitlecontroller.clear();
                        videourlcontroller.clear();
                        videolectureno.clear();
                      });
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
