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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: kBoxDecoration,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensure Column size fits content
              children: [
                SizedBox(
                  height: screenHeight * 0.08, // Adjusted to screen height
                ),
                Text(
                  'you are',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat-Bold',
                    fontSize: screenHeight * 0.02, // Adjusted to screen height
                  ),
                ),
                Text(
                  'NotAlone',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Satisfy',
                    fontSize: screenHeight * 0.07, // Adjusted to screen height
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.20, // Adjusted to screen height
                ),
                SizedBox(
                  width: screenWidth * 0.4, // Adjusted to screen width
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
                      fontSize: screenHeight * 0.020), // Adjusted to screen height
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
