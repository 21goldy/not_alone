import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:not_alone/constants.dart';
import 'package:not_alone/screens/account_page.dart';
import 'package:telephony/telephony.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:not_alone/screens/help_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart' hide Location;

double? latitude = 0;
double? longitude = 0;
bool isDebug = false;
List<dynamic> myContacts = [];
List<String> phoneNumbers = [];
bool showSpinner = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final Telephony telephony = Telephony.instance;
  Location location = Location();
  late LocationData locationData;
  String _address = '';
  bool showAddress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getLocationPermission();
    getLocation();
    getContacts(); // Initial fetch
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Screen has resumed, refetch contacts
      getContacts();
    }
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    getContacts(); // Fetch contacts whenever the widget is updated
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void getLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Location Service Not Enabled!"),
            content: const Text("You have raised a Alert Dialog Box"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          ),
        );
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Location Permission Not Granted"),
            content: const Text("You have raised a Alert Dialog Box"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          ),
        );
      }
    }
  }

  void getLocation() async {
    try {
      locationData = await location.getLocation();
      double? lat = locationData.latitude;
      double? long = locationData.longitude;

      latitude = lat;
      longitude = long;
      List<Placemark> placeMark = await placemarkFromCoordinates(lat!, long!);

      Placemark place = placeMark[0];

      _address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  getContacts() async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .get();

      setState(() {
        myContacts = data.data()!['myContacts'] ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch contacts: $e"),
        ),
      );
    }
  }

  void getHelp() {
    getLocation();
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Container(
            decoration: kBoxDecoration,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Text(
                      'Send Emergency Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: screenHeight * 0.045,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenHeight * 0.01),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });

                        getLocation();
                        getContacts();

                        try {
                          await FirebaseFirestore.instance
                              .collection('User')
                              .doc(FirebaseAuth.instance.currentUser?.email)
                              .collection('locations')
                              .add({
                            'uID': FirebaseAuth.instance.currentUser?.uid,
                            'address': _address,
                            'time': FieldValue.serverTimestamp(),
                          });

                          bool? permissionsGranted =
                          await telephony.requestPhoneAndSmsPermissions;

                          if (permissionsGranted == true) {
                            if (isDebug) {
                              telephony.sendSms(
                                  to: "1234567890",
                                  message:
                                  "Please Help... This is an emergency! My location https://maps.google.com/maps?q=$latitude,$longitude");
                            } else {
                              telephony.sendSms(
                                  to: "9893852948",
                                  message:
                                  "${FirebaseAuth.instance.currentUser?.email}\nPlease Help... This is an emergency! My location https://maps.google.com/maps?q=$latitude,$longitude");

                              myContacts.forEach((element) {
                                try {
                                  telephony.sendSms(
                                      to: element,
                                      message:
                                      "Please Help... This is an emergency! My location https://maps.google.com/maps?q=$latitude,$longitude");
                                } catch (e) {
                                  print(e);
                                }
                              });
                            }
                          } else {
                            print("Can't send messages!");
                          }

                          setState(() {
                            showSpinner = false;
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpScreen()),
                          );
                        } catch (e) {
                          print(e);
                        }
                        setState(() {
                          showAddress = true;
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        width: screenWidth * 0.55,
                        height: screenHeight * 0.35,
                        child: Center(
                          child: Text(
                            'Help',
                            style: TextStyle(
                                fontSize: screenHeight * 0.03,
                                fontFamily: 'Ubuntu-Medium'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenHeight * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: screenHeight * 0.03,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AccountPage()),
                            );
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Note: On clicking this help button we will send your current location to nearby help and your selected contact members!',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Ubuntu-Medium',
                              fontSize: screenHeight * 0.014,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
