import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:not_alone/screens/home_screen.dart';
import 'package:not_alone/screens/welcome_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MaterialApp(debugShowCheckedModeBanner: false, home: const NotAlone()));
}

class NotAlone extends StatelessWidget {
  const NotAlone({Key? key}) : super(key: key);

  final secureStorage = const FlutterSecureStorage();

  Future<bool> checkLoginStatus() async {
    String? value = await secureStorage.read(key: 'uid');

    if (value == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginStatus(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data == false) {
          return const WelcomeScreen();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              color: Colors.white, child: const CircularProgressIndicator());
        }
        return const HomeScreen();
      },
    );
  }
}
