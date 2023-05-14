import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Help is on the way!\n\n',
              style: TextStyle(fontSize: 30.0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Precautions:\n'),
                Text('1. Put your mobile phone on silent\n'),
                Text(
                    '2. Do not panic, Wait for the right chance and run for help'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
