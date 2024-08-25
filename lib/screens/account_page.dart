import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:not_alone/constants.dart';
import 'package:not_alone/screens/about_us.dart';
import 'package:not_alone/screens/contact_list.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> signOut() async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: 'uid');
  }

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
                    'NotAlone',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat-Bold',
                      fontSize: screenHeight * 0.06, // Adjusted to screen size
                    ),
                  ),
                  Text(
                    'Let\'s Make this world a better place to live!',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Ubuntu',
                      fontSize: screenHeight * 0.018, // Adjusted to screen size
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.06, // Adjusted to screen size
                  ),
                  optionsView(Icons.edit, 'My Contacts', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactList()),
                    );
                  }, screenHeight, screenWidth),
                  SizedBox(
                    height: screenHeight * 0.02, // Adjusted to screen size
                  ),
                  optionsView(Icons.adb_sharp, 'About Us', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUs()),
                    );
                  }, screenHeight, screenWidth),
                  SizedBox(
                    height: screenHeight * 0.02, // Adjusted to screen size
                  ),
                  optionsView(Icons.logout, 'Log Out', () {
                    signOut().then((value) async {
                      await Future.delayed(const Duration(seconds: 2));
                    });
                    SystemChannels.platform
                        .invokeMethod<void>('SystemNavigator.pop');
                  }, screenHeight, screenWidth),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InkWell optionsView(IconData icon, String text, VoidCallback onTap, screenHeight, screenWidth) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: screenHeight * 0.025, // Adjusted to screen size
            color: Colors.white,
          ),
          SizedBox(
            width: screenWidth * 0.03, // Adjusted to screen size
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Ubuntu',
              fontSize: screenHeight * 0.025, // Adjusted to screen size
            ),
          ),
        ],
      ),
    );
  }
}
