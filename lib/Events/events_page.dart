import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hakikat_app_new/Events/components/event_tile.dart';
import 'package:hakikat_app_new/Events/event_discription.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
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

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: AppColors.greenthemecolor,
        // foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: BackButton(),
        title: Text(
          'EVENTS',
          style: TextStyle(
              // color: Colors.white,

              ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(child: notificationFetcher())
        ],
      ),
    );
  }

  Widget notificationFetcher() {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return StreamBuilder(
      stream: events,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // Sort the list of notifications based on timestamp
          // Assuming 'id' is the timestamp

          return ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(height: 20);
            },
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                child: EventsTile(
                    ontap: () {
                      nextScreen(
                          context,
                          EventDiscription(
                              eventname: snapshot.data!.docs[index]['EventName']
                                  .toString(),
                              eventdetails: snapshot
                                  .data!.docs[index]['Event Details']
                                  .toString(),
                              hostname: snapshot.data!.docs[index]['HostName']
                                  .toString(),
                              time:
                                  snapshot.data!.docs[index]['Time'].toString(),
                              date: snapshot.data!.docs[index]['EventDate']
                                  .toString(),
                              img: snapshot.data!.docs[index]['BannerImg']
                                  .toString()));
                    },
                    eventname:
                        snapshot.data!.docs[index]['EventName'].toString(),
                    hostname: snapshot.data!.docs[index]['HostName'].toString(),
                    time: snapshot.data!.docs[index]['Time'].toString(),
                    date: snapshot.data!.docs[index]['EventDate'].toString(),
                    img: snapshot.data!.docs[index]['BannerImg'].toString()),
              );

              // );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
