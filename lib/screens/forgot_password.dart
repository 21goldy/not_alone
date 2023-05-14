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
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: kBoxDecoration,
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
                      'Reset Password',
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: LoginFields(
                      formHintText: 'Enter Your Email',
                      formPrefixIcon: Icons.email,
                      obscureText: false,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 13,
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

                            // print('sent');
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
                        fontSize: 18.0),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
