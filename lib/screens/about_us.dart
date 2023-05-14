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
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: kBoxDecoration,
        child: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'About Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat-Bold',
                      fontSize: 50,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'We are Team NotAlone. We aim to give the freedom to every person to travel safe. Our aim is to help people share there live location to the nearby restaurants/places to assist the needy with the earliest help!\n',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    'Made by, \n',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '20BAI10069	RIYA SHARMA\n20BAI10188	NAYAN PANDA\n20BCE10093	ANANYA PRASAD\n20BCE10529	JAYESH MEHTA\n20BCY10155	GOLDY GOUR\n20BCY10179	SMARANI BASU\n20MIM10061	SHAGUN SRIVASTAV\n20MIM10069	SNEHA PRASAD',
                    style: TextStyle(color: Colors.white),
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
