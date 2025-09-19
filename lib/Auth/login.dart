import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/responsive_helper.dart';
import 'package:hakikat_app_new/Utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formfield = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool _isPasswordVisible = false;
  bool loading = false;
  DateTime? currentBackPressTime;
  final _auth = FirebaseAuth.instance;
  final CollectionReference controllerCollection =
      FirebaseFirestore.instance.collection('Controllers');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  Future<String> fetchIsLoginValue() async {
    try {
      DocumentSnapshot documentSnapshot =
          await controllerCollection.doc('MobileNoLogin').get();
      String isLogin = documentSnapshot['Isloginactivated'];
      return isLogin;
    } catch (error) {
      return error.toString();
    }
  }

  void login() {
    setState(() {
      loading = true;
    });

    _auth
        .signInWithEmailAndPassword(
            email: emailcontroller.text.toString(),
            password: passwordcontroller.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage('Login successful');
      context.go('/home');
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage('Login failed. Please check your credentials.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    final isWeb = kIsWeb;

    return WillPopScope(
      onWillPop: () async {
        if (currentBackPressTime == null ||
            DateTime.now().difference(currentBackPressTime!) >
                Duration(seconds: 2)) {
          currentBackPressTime = DateTime.now();
          if (!isWeb) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Press Back Again to exit')),
            );
          }
          return false;
        }
        if (!isWeb) exit(0);
        return true;
      },
      child: Scaffold(
        body: ResponsiveWidget(
          mobile: _buildMobileLayout(height, width),
          tablet: _buildTabletLayout(height, width),
          desktop: _buildDesktopLayout(height, width),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(double height, double width) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.055),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: IntrinsicHeight(
            child: _buildLoginForm(height, width, isMobile: true),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(double height, double width) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(40),
              child: _buildLoginForm(height, width, isMobile: false),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(double height, double width) {
    return Row(
      children: [
        // Left side - Branding
        Expanded(
          child: Container(
            color: AppColors.greenthemecolor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/hakikat.png',
                    width: 120,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.store,
                        size: 80,
                        color: AppColors.greenthemecolor,
                      );
                    },
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Welcome to Hakeekat',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Your trusted platform for natural products',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right side - Login form
        Expanded(
          child: Container(
            padding: EdgeInsets.all(80),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  child: _buildLoginForm(height, width, isMobile: false),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(double height, double width,
      {required bool isMobile}) {
    return Column(
      mainAxisAlignment:
          isMobile ? MainAxisAlignment.center : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) ...[
          SizedBox(height: 40), // Top padding for mobile
          // Mobile header
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.greenthemecolor,
              child: Image.asset(
                'assets/hakikat.png',
                width: 70,
                height: 70,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.store,
                    size: 50,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 24),
        ],

        Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87,
            fontSize: isMobile ? 28 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Sign in to your account',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: isMobile ? 16 : 18,
          ),
        ),
        SizedBox(height: isMobile ? 32 : 48), // Reduced spacing for mobile

        Form(
          key: _formfield,
          child: Column(
            children: [
              // Email Field
              TextFormField(
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined,
                      color: AppColors.greenthemecolor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.greenthemecolor, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: passwordcontroller,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline,
                      color: AppColors.greenthemecolor),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.greenthemecolor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.greenthemecolor, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.push('/forgot-password');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.greenthemecolor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isMobile ? 24 : 32), // Reduced spacing for mobile

        // Login Button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: loading
                ? null
                : () {
                    if (_formfield.currentState!.validate()) {
                      login();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenthemecolor,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: loading
                ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),

        SizedBox(height: 20), // Reduced spacing for mobile

        // Sign Up Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextButton(
              onPressed: () {
                context.push('/signup');
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: AppColors.greenthemecolor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16), // Reduced spacing for mobile

        // Phone Login Option (if enabled)
        FutureBuilder<String>(
          future: fetchIsLoginValue(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data == '1') {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR',
                              style: TextStyle(color: Colors.grey[600])),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.push('/login-phone');
                        },
                        icon:
                            Icon(Icons.phone, color: AppColors.greenthemecolor),
                        label: Text(
                          'Continue with Phone',
                          style: TextStyle(
                            color: AppColors.greenthemecolor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.greenthemecolor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }
          },
        ),

        if (isMobile) SizedBox(height: 40), // Bottom padding for mobile
      ],
    );
  }
}
