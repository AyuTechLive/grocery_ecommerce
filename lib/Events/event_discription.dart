import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventDiscription extends StatefulWidget {
  final String eventname;
  final String hostname;
  final String time;
  final String date;
  final String img;
  final String eventdetails;
  const EventDiscription(
      {super.key,
      required this.eventname,
      required this.hostname,
      required this.time,
      required this.date,
      required this.img,
      required this.eventdetails});

  @override
  State<EventDiscription> createState() => _EventDiscriptionState();
}

class _EventDiscriptionState extends State<EventDiscription> {
  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)),
            child: Column(children: [
              Container(
                width: width,
                height: height * 0.3,
                child: Image.network(
                  widget.img,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                children: [
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.5,
                        child: Text(
                          widget.eventname,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Sahitya',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        'HOST : ${widget.hostname}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          // fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        'TIME - ${widget.time}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          // fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Image.asset('assets/eventimg.png'),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        widget.date,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          // fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              )
            ]),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Row(children: [
            SizedBox(
              width: width * 0.05,
            ),
            Text(
              'Event Detail:- ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            )
          ]),
          SizedBox(
            height: height * 0.02,
          ),
          SizedBox(
            width: width * 0.9,
            child: Text(widget.eventdetails),
          ),
          SizedBox(
            height: height * 0.02,
          )
        ]),
      ),
    );
  }
}
