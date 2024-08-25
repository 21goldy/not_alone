import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:not_alone/components/login_fields.dart';
import 'package:not_alone/components/rounded_button.dart';
import 'package:not_alone/constants.dart';
import 'package:not_alone/screens/home_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _auth = FirebaseAuth.instance;
  late bool showSpinner = false;

  late String email;
  late String password;
  bool _obscureText = true; // Boolean to manage password visibility

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return GestureDetector(
      onTap: () {
        // Hide the keyboard when tapping anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Container(
            decoration: kBoxDecoration,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.15), // Responsive height
                      Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat-Bold',
                            fontSize: screenHeight * 0.05, // Responsive font size
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05), // Responsive height
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
                      SizedBox(height: screenHeight * 0.01), // Responsive height
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
                      SizedBox(height: screenHeight * 0.01), // Responsive height
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                      SizedBox(height: screenHeight * 0.02), // Responsive height
                      SizedBox(
                        width: screenWidth * 0.4, // Responsive width
                        child: RoundedButton(
                          title: 'Register',
                          color: Colors.white,
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);

                              await FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(email)
                                  .set({
                                'myContacts': [],
                              });

                              Navigator.popUntil(
                                  context,
                                  ModalRoute.withName('/welcome_screen'));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                              );

                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              print(e);
                              print('Oops! Some error occurred.');
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
