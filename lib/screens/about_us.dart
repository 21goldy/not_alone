import 'package:flutter/material.dart';
import 'package:not_alone/constants.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    // Fetching screen size
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: kBoxDecoration,
        child: Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.05),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'About Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat-Bold',
                      fontSize: screenHeight * 0.06, // Adjusted to screen size
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03, // Adjusted to screen size
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02), // Adjusted to screen size
                    child: Text(
                      'NotAlone aims to give every person the freedom to travel safe. You can share your live location with your contacts in one click. Let\'s make this world a better place to live!\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.018, // Adjusted to screen size
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.04, // Adjusted to screen size
                  ),
                  Text(
                    'Made with ❤ by Goldy!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.018, // Adjusted to screen size
                    ),
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
