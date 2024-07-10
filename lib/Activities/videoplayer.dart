import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LectureVideoPlayer extends StatefulWidget {
  final String videoURL;
  final String videoTitle;
  final String videoSubtitle;
  const LectureVideoPlayer(
      {super.key,
      required this.videoURL,
      required this.videoTitle,
      required this.videoSubtitle});

  @override
  State<LectureVideoPlayer> createState() => _LectureVideoPlayerState();
}

class _LectureVideoPlayerState extends State<LectureVideoPlayer> {
  late YoutubePlayerController _controller;
  bool isFullScreen = false;
  @override
  void initState() {
    // TODO: implement initState
    final videoid = YoutubePlayer.convertUrlToId(widget.videoURL);
    _controller = YoutubePlayerController(
        initialVideoId: videoid!, flags: YoutubePlayerFlags(isLive: false)

        // flags: YoutubePlayerFlags(autoPlay: false, hideControls: false) );
        );

    super.initState();

    _controller.addListener(() {
      if (_controller.value.isFullScreen != isFullScreen) {
        setState(() {
          isFullScreen = _controller.value.isFullScreen;
        });

        if (isFullScreen) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
            // SystemUiOverlay.top,
            // SystemUiOverlay.bottom,
          ]);
          // Perform actions when entering full-screen mode

          // Add your logic here for full-screen mode
        } else {
          // Perform actions when exiting full-screen mode
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
            // SystemUiOverlay.top,
            // SystemUiOverlay.bottom,
          ]);

          // Add your logic here for normal mode
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    final String subtitle = widget.videoSubtitle;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height * 0.05,
          ),
          Expanded(
            child: YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Color(0xFF7455F7),
                  progressColors: ProgressBarColors(
                      playedColor: Color(0xFF7455F7),
                      handleColor: Color(0xFF7455F7)),
                  topActions: [
                    BackButton(
                      color: Colors.white,
                    ),
                  ],
                  //  liveUIColor: Color(0xFF7455F7),
                ),
                builder: (context, player) {
                  return Column(
                    children: [
                      // some widgets
                      player,
                      Container(
                          width: width,
                          height: height * 0.09,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: SizedBox(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  width * 0.03, height * 0.01, 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.videoTitle,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    softWrap: true,
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.07,
                                        top: height * 0.005),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Text(
                                            '$subtitle mins',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      //some other widgets
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _controller.dispose();
    super.dispose();
  }
}
