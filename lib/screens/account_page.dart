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
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: kBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'NotAlone',
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
                    height: 50.0,
                  ),
                  optionsView(Icons.edit, 'My Contacts', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactList()),
                    );
                  }),
                  const SizedBox(
                    height: 15.0,
                  ),
                  optionsView(Icons.adb_sharp, 'About Us', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUs()),
                    );
                  }),
                  const SizedBox(
                    height: 15.0,
                  ),
                  optionsView(Icons.logout, 'Log Out', () {
                    signOut().then((value) async {
                      await Future.delayed(const Duration(seconds: 2));
                    });
                    SystemChannels.platform
                        .invokeMethod<void>('SystemNavigator.pop');
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InkWell optionsView(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Ubuntu',
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
