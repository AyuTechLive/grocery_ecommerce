import 'package:flutter/material.dart';

class ImageOpeningPage extends StatelessWidget {
  final String imgurl;
  const ImageOpeningPage({super.key, required this.imgurl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: BackButton(),
        //  actions: [IconButton(onPressed: () {}, icon: Icon(Icons.share))],
      ),
      body: Container(
        color: Colors.black,
        child: Center(
            child: Image.network(
          imgurl,
          fit: BoxFit.fill,
        )),
      ),
    );
  }
}
