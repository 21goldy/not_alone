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

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Container(
          decoration: kBoxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat-Bold',
                            fontSize: 35,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
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
                      const SizedBox(
                        height: 10,
                      ),
                      LoginFields(
                        formHintText: 'Enter Your Password',
                        formPrefixIcon: Icons.password,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      SizedBox(
                        width: 150,
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

                                FirebaseFirestore.instance
                                    .collection('User')
                                    .doc(FirebaseAuth
                                        .instance.currentUser?.email);

                                Navigator.popUntil(context,
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
                                print('Oops! Some error occurred.');
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            },
                            fontSize: 18.0),
                      )
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
