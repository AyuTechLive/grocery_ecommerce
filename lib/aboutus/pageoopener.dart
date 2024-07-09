import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class PageOpener extends StatefulWidget {
  final String url;
  final String title;
  const PageOpener({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<PageOpener> createState() => _PageOpenerState();
}

class _PageOpenerState extends State<PageOpener> {
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(),
            ),
            onWebViewCreated: (InAppWebViewController controller) {},
            onLoadStart: (InAppWebViewController controller, Uri? url) {},
            onLoadStop: (InAppWebViewController controller, Uri? url) {},
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
          if (progress < 1.0)
            Positioned(
              top: height * 0.5,
              left: width * 0.5,
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff321f73)),
              ),
            ),
        ],
      ),
    );
  }
}
