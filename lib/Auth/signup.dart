import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/responsive_helper.dart';
import 'package:hakikat_app_new/Utils/utils.dart';
import 'package:hakikat_app_new/Auth/login.dart';
import 'package:hakikat_app_new/Home/mainpage.dart';

class SignUpNew extends StatefulWidget {
  const SignUpNew({super.key});

  @override
  State<SignUpNew> createState() => _SignUpNewState();
}

class _SignUpNewState extends State<SignUpNew> {
  bool loading = false;
  final _formfield = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final namecontroller = TextEditingController();
  final referalcodecontroller = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('Users');
  final fireStore2 = FirebaseFirestore.instance.collection('Referals');

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    confirmPasswordController.dispose();
    namecontroller.dispose();
    referalcodecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    final isWeb = kIsWeb;

    return Scaffold(
      body: ResponsiveWidget(
        mobile: _buildMobileLayout(height, width),
        tablet: _buildTabletLayout(height, width),
        desktop: _buildDesktopLayout(height, width),
      ),
    );
  }

  Widget _buildMobileLayout(double height, double width) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.055, vertical: height * 0.05),
      child: _buildSignUpForm(height, width, isMobile: true),
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
              child: _buildSignUpForm(height, width, isMobile: false),
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
                  'Join Hakeekat Today',
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
                    'Create your account and start your journey with natural, organic products',
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
        // Right side - Sign up form
        Expanded(
          child: Container(
            padding: EdgeInsets.all(80),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  child: _buildSignUpForm(height, width, isMobile: false),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm(double height, double width,
      {required bool isMobile}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMobile) ...[
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
          'Create Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87,
            fontSize: isMobile ? 28 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Sign up to get started',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: isMobile ? 16 : 18,
          ),
        ),
        SizedBox(height: isMobile ? 32 : 40),

        Form(
          key: _formfield,
          child: Column(
            children: [
              // Name Field
              TextFormField(
                controller: namecontroller,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outline,
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
                    return 'Please enter your name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

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

              // Referral Code Field (Optional)
              TextFormField(
                controller: referalcodecontroller,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Referral Code (Optional)',
                  hintText: 'Enter referral code if you have one',
                  prefixIcon: Icon(Icons.card_giftcard_outlined,
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
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: passwordcontroller,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Create a strong password',
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
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Confirm Password Field
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  prefixIcon: Icon(Icons.lock_outline,
                      color: AppColors.greenthemecolor),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isConfirmPasswordVisible
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
                    return 'Please confirm your password';
                  }
                  if (value != passwordcontroller.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Terms and Conditions Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                    activeColor: AppColors.greenthemecolor,
                  ),
                  Expanded(
                    child: Text(
                      'I agree to the Terms and Conditions and Privacy Policy',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading || !_acceptTerms ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenthemecolor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: loading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        // Login Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account? ",
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: AppColors.greenthemecolor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleSignUp() {
    if (_formfield.currentState!.validate()) {
      DateTime currentDate = DateTime.now();
      String formattedDate =
          '${currentDate.day}-${currentDate.month}-${currentDate.year}';

      String enteredReferalCode = referalcodecontroller.text.trim();

      if (enteredReferalCode.isEmpty) {
        // No referral code provided
        _createUserAccount(formattedDate, null);
      } else {
        // Referral code provided, validate it first
        fireStore2.doc(enteredReferalCode).get().then((docSnapshot) {
          if (docSnapshot.exists) {
            // Referral code exists, proceed with user creation
            _createUserAccount(formattedDate, enteredReferalCode);
          } else {
            // Referral code not found
            Utils().toastMessage('Invalid referral code');
          }
        }).catchError((error) {
          Utils().toastMessage('Error checking referral code');
        });
      }
    }
  }

  void _createUserAccount(String formattedDate, String? referralCode) {
    String lastfour = DateTime.now().microsecondsSinceEpoch.toString();
    int length = lastfour.length;
    String referalId = namecontroller.text.substring(0, 4) +
        DateTime.now().microsecondsSinceEpoch.toString().substring(length - 4);

    setState(() {
      loading = true;
    });

    _auth
        .createUserWithEmailAndPassword(
      email: emailcontroller.text.toString(),
      password: passwordcontroller.text.toString(),
    )
        .then((value) {
      String id = emailcontroller.text.toString();
      fireStore.doc(id).set({
        'Email': emailcontroller.text.toString(),
        'Password': passwordcontroller.text.toString(),
        'UID': DateTime.now().microsecondsSinceEpoch.toString(),
        'My Courses': [],
        'Favorites': [],
        'DOJ': formattedDate,
        'Name': namecontroller.text.toString(),
        'Wallet': "0",
        'ReferalId': referalId
      }).then((value) {
        setState(() {
          loading = false;
          Utils().toastMessage('Account Successfully Created');
        });

        // Sign in the user
        _auth
            .signInWithEmailAndPassword(
                email: emailcontroller.text.toString(),
                password: passwordcontroller.text.toString())
            .then((value) {
          // Create referral document for the new user
          fireStore2.doc(referalId).set({
            "id": referalId,
            "Email": emailcontroller.text.toString(),
            "count": "0"
          }).then((value) {
            if (referralCode != null) {
              // Update referral count if referral code was used
              _updateReferralCount(referralCode);
            } else {
              // Navigate to main page
              Utils().toastMessage('Login successful');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(),
                ),
              );
            }
          }).onError((error, stackTrace) {
            Utils().toastMessage('Error While Creating Account Try Again');
          });
        });
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage('Error While Creating Account Try Again');
      setState(() {
        loading = false;
      });
    });
  }

  void _updateReferralCount(String referralCode) {
    fireStore2.doc(referralCode).get().then((docSnapshot) async {
      if (docSnapshot.exists) {
        // Update the referrer's referral list
        DocumentReference userDocRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(docSnapshot.data()?['Email']);
        await userDocRef.update({
          'MyReferals': FieldValue.arrayUnion([emailcontroller.text.toString()])
        });

        // Update the new user's "referred by" field
        DocumentReference newUserDocRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(emailcontroller.text.toString());
        await newUserDocRef
            .update({'ReferredBy': docSnapshot.data()?['Email']});
      }
    }).then((value) {
      // Update referral count
      fireStore2.doc(referralCode).update({
        'count': FieldValue.increment(1),
      }).then((_) {
        Utils().toastMessage('Login successful');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      }).catchError((error) {
        Utils().toastMessage('Error updating referral count');
      });
    });
  }
}
