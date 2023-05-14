import 'package:cloud_firestore/cloud_firestore.dart';
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

  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Material(
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
                        const Text(
                          'Hey!',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat-Bold',
                            fontSize: 50,
                          ),
                        ),
                        const Text(
                          'Let\'s Make this world a better place to live!',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ubuntu',
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
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
                              title: 'Login',
                              color: Colors.white,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);

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
                              textColor: Colors.deepPurple,
                              fontSize: 18.0),
                        )
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
                          child: const Text(
                            'Create New Account',
                            style: TextStyle(
                                color: Colors.black38, fontSize: 13.0),
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
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 13.0),
                            ))
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
