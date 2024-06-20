import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Splashscreen/splashservices.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.width;
    final double widht = screensize.height;
    return Scaffold(
        backgroundColor: AppColors.greenthemecolor,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: ClipRRect(
                  child: CircleAvatar(
                radius: 120,
                child: Image.asset(
                  'assets/hakikat.png',
                  scale: 1.0,
                  fit: BoxFit.fill,
                ),
              )),
            ),

            //    Container(
            //       height: height * 0.55,
            //       width: widht * 0.27,
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(50),
            //         child: Image.network(
            //           'https://firebasestorage.googleapis.com/v0/b/fir-d8752.appspot.com/o/WhatsApp%20Image%202023-12-19%20at%2019.32.33.jpeg?alt=media&token=3d6e78f0-0795-4043-86be-da547e2472f7',
            //           scale: 1.0,
            //           fit: BoxFit.fill,
            //         ),
            //       )),
            // )
          ),
        ]));
  }
}
