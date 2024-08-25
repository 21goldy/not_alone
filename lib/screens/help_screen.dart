import 'package:flutter/material.dart';
import 'package:not_alone/constants.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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
                  'Help is on the way!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat-Bold',
                    fontSize: screenHeight * 0.04, // Adjusted to screen height
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05, // Space between text sections
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Precautions:',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat-Bold',
                          fontSize: screenHeight * 0.03, // Adjusted to screen height
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02), // Space between items
                      Text(
                        '1. Put your mobile phone on silent.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.020, // Adjusted to screen height
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01), // Space between items
                      Text(
                        '2. Remain calm and assess your situation carefully before acting.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.020, // Adjusted to screen height
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01), // Space between items
                      Text(
                        '3. If you can safely leave the area, do so as soon as possible.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.020, // Adjusted to screen height
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01), // Space between items
                      Text(
                        '4. If you have access to emergency contacts, use them immediately.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.020, // Adjusted to screen height
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
