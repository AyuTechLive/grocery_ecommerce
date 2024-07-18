import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/Farmerevent/eventile.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/addfarmerevent.dart';
import 'package:hakikat_app_new/AdminSide/addevents.dart';

import 'package:hakikat_app_new/Utils/colors.dart';

class MainEventPage extends StatefulWidget {
  const MainEventPage({super.key});

  @override
  State<MainEventPage> createState() => _MainEventPageState();
}

class _MainEventPageState extends State<MainEventPage> {
  late Stream<QuerySnapshot> events;
  final CollectionReference eventcollection =
      FirebaseFirestore.instance.collection('events');

  @override
  void initState() {
    super.initState();
    events = getEventsStream();
  }

  Stream<QuerySnapshot> getEventsStream() {
    return eventcollection.snapshots();
  }

  void deleteEvent(String eventId) {
    eventcollection.doc(eventId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddEvent())),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Add Event', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.greenthemecolor,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Events',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Expanded(child: notificationFetcher())
        ],
      ),
    );
  }

  Widget notificationFetcher() {
    final Size screensize = MediaQuery.of(context).size;
    final double width = screensize.width;
    return StreamBuilder(
      stream: events,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(height: 20);
            },
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var eventData = snapshot.data!.docs[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: EventsTile(
                  eventname: eventData['EventName'].toString(),
                  hostname: eventData['HostName'].toString(),
                  time: eventData['Time'].toString(),
                  date: eventData['EventDate'].toString(),
                  img: eventData['BannerImg'].toString(),
                  ontap: () {
                    // Implement navigation to event details page
                  },
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete Event"),
                          content: Text(
                              "Are you sure you want to delete this event?"),
                          actions: [
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text("Delete"),
                              onPressed: () {
                                deleteEvent(eventData.id);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
