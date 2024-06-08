// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hakikat_app_new/Home/homepage.dart';
// import 'package:hakikat_app_new/Utils/colors.dart';

// class MainPage extends StatefulWidget {
//   final int index;
//   const MainPage({super.key, this.index = 0});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int currentindex = 0;
//   DateTime? currentBackPressTime;
//   @override
//   Widget build(BuildContext context) {
//     final Size screensize = MediaQuery.of(context).size;
//     final double height = screensize.height;
//     final double width = screensize.width;
//     return WillPopScope(
//       onWillPop: () async {
//         if (currentindex != 0) {
//           setState(() {
//             currentindex = 0;
//           });
//           return false;
//         } else {
//           if (currentBackPressTime == null ||
//               DateTime.now().difference(currentBackPressTime!) >
//                   Duration(seconds: 2)) {
//             currentBackPressTime = DateTime.now();
//             // Utils().toastMessage('Press Back Again to exit');
//             return false;
//           }
//           exit(0);
//         }
//       },
//       child: Scaffold(
//           body: pages[currentindex],
//           bottomNavigationBar: BottomNavigationBar(
//             items: [
//               BottomNavigationBarItem(
//                 icon: ImageIcon(AssetImage('assets/shop.png')),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: ImageIcon(AssetImage('assets/search.png')),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: ImageIcon(AssetImage('assets/cart.png')),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: ImageIcon(AssetImage('assets/wishlist.png')),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: ImageIcon(AssetImage('assets/account.png')),
//                 label: 'Home',
//               ),

//               // BottomNavigationBarItem(
//               //     icon: Image.asset('assets/icons/'),
//               //     label: 'Favorite'),
//             ],
//             onTap: (index) {
//               print(index);
//               setState(() {
//                 currentindex = index;
//               });
//             },
//             currentIndex: currentindex,
//             type: BottomNavigationBarType.fixed,
//             unselectedItemColor: Colors.black,
//             // showSelectedLabels: false,
//             // showUnselectedLabels: false,
//             backgroundColor: Colors.white,
//             selectedItemColor: AppColors.greenthemecolor,
//             selectedIconTheme: IconThemeData(color: AppColors.greenthemecolor),
//             // selectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
//           )),
//     );
//   }

//   final pages = [
//     HomePage(),
//     Center(
//       child: Text('Categories'),
//     ),
//     Center(
//       child: Text('cart'),
//     ),
//     Center(
//       child: Text('favorite'),
//     ),
//     Center(
//       child: Text('account'),
//     )

//     //  Profile(),
//   ];
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Explore/explore.dart';
import 'package:hakikat_app_new/Home/homepage.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;
  int _currentIndex = 0; // Set default index to 1 (Play)
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: _currentIndex); // Set initial page to the default index
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          if (currentBackPressTime == null ||
              DateTime.now().difference(currentBackPressTime!) >
                  Duration(seconds: 2)) {
            currentBackPressTime = DateTime.now();
            // MySnackbar.show(context, 'Press Back Again to exit');

            return false;
          }
          exit(0);
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            HomePage(),
            Explore(),
            Center(
              child: Text('cart'),
            ),
            Center(
              child: Text('favorite'),
            ),
            Center(
              child: Text('account'),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black,
          iconSize: height * 0.025,

          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.greenthemecolor,
          selectedIconTheme: IconThemeData(
            color: AppColors.greenthemecolor,
          ),
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (index) {
            // Change the tab when a bottom navigation item is tapped
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/shop.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/search.png')),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/cart.png')),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/wishlist.png')),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/account.png')),
              label: 'Account',
            ),

            // BottomNavigationBarItem(
            //     icon: Image.asset('assets/icons/'),
            //     label: 'Favorite'),
          ],
        ),
      ),
    );
  }

  // Future<void> _launchURL(String urlString) async {
  //   final Uri url = Uri.parse(urlString);
  //   if (!await launchUrl(url)) {
  //     throw 'Could not launch $urlString';
  //   }
  // }
}
