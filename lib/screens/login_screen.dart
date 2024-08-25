import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:not_alone/constants.dart';
import 'package:not_alone/screens/create_account_screen.dart';
import 'package:not_alone/screens/forgot_password.dart';
import 'package:not_alone/screens/home_screen.dart';
import 'package:not_alone/components/login_fields.dart';
import 'package:not_alone/components/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late bool showSpinner = false;
  bool _obscureText = true; // Boolean to manage password visibility

  late String email;
  late String password;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Add a listener to prevent the keyboard from showing when navigating back
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!emailFocusNode.hasFocus && !passwordFocusNode.hasFocus) {
        FocusScope.of(context).unfocus(); // Prevent keyboard from showing
      }
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Close the keyboard
          },
          child: SafeArea(
            child: Container(
              decoration: kBoxDecoration,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.2, // Responsive height
                        ),
                        Text(
                          'Hey!',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat-Bold',
                            fontSize: screenHeight * 0.08, // Responsive font size
                          ),
                        ),
                        Text(
                          'Let\'s Make this world a better place to live!',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ubuntu',
                            fontSize: screenHeight * 0.018, // Responsive font size
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03, // Responsive height
                        ),
                        LoginFields(
                          formHintText: 'Enter Your Email',
                          formPrefixIcon: Icons.email,
                          obscureText: false,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.01, // Responsive height
                        ),
                        LoginFields(
                          formHintText: 'Enter Your Password',
                          formPrefixIcon: Icons.password,
                          obscureText: _obscureText, // Set obscureText based on _obscureText
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.01, // Responsive height
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: !_obscureText,
                              onChanged: (value) {
                                setState(() {
                                  _obscureText = !value!; // Toggle the _obscureText boolean
                                });
                              },
                            ),
                            Text(
                              'Show Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.018, // Responsive font size
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.02, // Responsive height
                        ),
                        SizedBox(
                          width: screenWidth * 0.35, // Responsive width
                          child: RoundedButton(
                            title: 'Login',
                            color: Colors.white,
                            onPressed: () async {
                              FocusScope.of(context).unfocus(); // Close the keyboard
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                const secureStorage = FlutterSecureStorage();

                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);

                                final User? user = _auth.currentUser;

                                await secureStorage.write(
                                    key: 'uid', value: user?.uid);

                                Navigator.popUntil(context,
                                    ModalRoute.withName('/welcome_screen'));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const HomeScreen()),
                                );

                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            },
                            fontSize: screenHeight * 0.020, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const CreateAccountScreen()),
                            );
                          },
                          child: Text(
                            'Create New Account',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.015, // Responsive font size
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const ForgotPassword()),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenHeight * 0.015, // Responsive font size
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
