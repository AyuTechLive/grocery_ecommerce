import 'package:flutter/material.dart';

class EventDiscription extends StatelessWidget {
  final String eventname;
  final String hostname;
  final String time;
  final String date;
  final String img;
  final String eventdetails;

  const EventDiscription({
    Key? key,
    required this.eventname,
    required this.hostname,
    required this.time,
    required this.date,
    required this.img,
    required this.eventdetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  img,
                  width: width,
                  height: height * 0.4,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: width,
                  height: height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventname,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          _buildInfoChip(Icons.person, hostname),
                          SizedBox(width: 10),
                          _buildInfoChip(Icons.access_time, time),
                          SizedBox(width: 10),
                          _buildInfoChip(Icons.calendar_today, date),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    eventdetails,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
