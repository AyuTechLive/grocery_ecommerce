import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Account/account.dart';
import 'package:hakikat_app_new/AdminSide/adminpanel.dart';
import 'package:hakikat_app_new/Cart/cart.dart';
import 'package:hakikat_app_new/Cart/democart.dart';
import 'package:hakikat_app_new/Explore/explore.dart';
import 'package:hakikat_app_new/Favorites/favorites.dart';
import 'package:hakikat_app_new/Home/homepage.dart';
import 'package:hakikat_app_new/OrderSucess/myorder.dart';

import 'package:hakikat_app_new/Utils/colors.dart';

class MainPage extends StatefulWidget {
  final int index;
  const MainPage({super.key, this.index = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _pageController = PageController(initialPage: _currentIndex);
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
          _pageController.jumpToPage(0); // Set the page to Home
          return false;
        } else {
          if (currentBackPressTime == null ||
              DateTime.now().difference(currentBackPressTime!) >
                  Duration(seconds: 2)) {
            currentBackPressTime = DateTime.now();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Press Back Again to exit'),
              ),
            );
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
            CartScreen(),
            FavoritesScreen(),
            Account()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black,
          iconSize: height * 0.025,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.greenthemecolor,
          selectedIconTheme: IconThemeData(color: AppColors.greenthemecolor),
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (index) {
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
          ],
        ),
      ),
    );
  }
}
