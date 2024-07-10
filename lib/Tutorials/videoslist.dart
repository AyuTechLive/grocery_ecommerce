import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hakeekat_farmer_version/Activities/videoplayer.dart';
import 'package:hakeekat_farmer_version/Utils/colors.dart';
import 'package:hakeekat_farmer_version/Utils/widget.dart';

class VideosListScreen extends StatefulWidget {
  @override
  _VideosListScreenState createState() => _VideosListScreenState();
}

class _VideosListScreenState extends State<VideosListScreen> {
  final databaseReference = FirebaseDatabase.instance.ref('videos');
  List<Video> videos = [];

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  void fetchVideos() {
    databaseReference.onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map;
      Video video = Video(
        id: snapshot.key ?? '',
        title: values['Title'] ?? '',
        subtitle: values['Subtitle'] ?? '',
        videoLink: values['Video Link'] ?? '',
        imageUrl: values['imageUrl'] ?? '',
      );
      setState(() {
        videos.add(video);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Your Videos',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoListItem(video: videos[index]);
        },
      ),
    );
  }
}

class VideoListItem extends StatelessWidget {
  final Video video;

  const VideoListItem({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: video.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.error, size: 50, color: Colors.red),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  video.subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Play',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        nextScreen(
                            context,
                            LectureVideoPlayer(
                                videoURL: video.videoLink,
                                videoTitle: video.title,
                                videoSubtitle: video.subtitle));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenthemecolor,
                        // primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        // Implement more options
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Video {
  final String id;
  final String title;
  final String subtitle;
  final String videoLink;
  final String imageUrl;

  Video({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.videoLink,
    required this.imageUrl,
  });
}
