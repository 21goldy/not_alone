import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:not_alone/components/login_fields.dart';
import 'package:not_alone/components/rounded_button.dart';
import 'package:not_alone/constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = FirebaseAuth.instance;
  late bool showSpinner = false;

  late String email;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Material(
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
                      Center(
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat-Bold',
                            fontSize: screenHeight * 0.045, // Responsive font size
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.1, // Responsive height
                      ),
                      LoginFields(
                        rightPadding: 0,
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
                        height: screenHeight * 0.02, // Responsive height
                      ),
                      Center(
                        child: RoundedButton(
                            title: 'Send Reset Link',
                            color: Colors.white,
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                await _auth.sendPasswordResetEmail(
                                  email: email,
                                );

                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Oops! Some error occurred.'),
                                ));

                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            },
                            fontSize: screenHeight * 0.02, // Responsive font size
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
    );
  }
}
