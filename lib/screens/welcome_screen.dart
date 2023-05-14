import 'package:flutter/material.dart';
import 'package:not_alone/constants.dart';
import 'package:not_alone/screens/login_screen.dart';
import 'package:not_alone/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: kBoxDecoration,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              const Text(
                'you are',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat-Bold',
                ),
              ),
              const Text(
                'NotAlone',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Satisfy',
                  fontSize: 50,
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              SizedBox(
                width: 150,
                child: RoundedButton(
                    title: 'Get Started',
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    fontSize: 18.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
