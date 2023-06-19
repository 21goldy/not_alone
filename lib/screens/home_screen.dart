import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:not_alone/constants.dart';
import 'package:not_alone/screens/account_page.dart';
import 'package:telephony/telephony.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:not_alone/screens/help_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:not_alone/model/nearby_response.dart' hide Location;

double? latitude = 0;
double? longitude = 0;
List<String> phoneNumbers = [];
bool isDebug = true;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Telephony telephony = Telephony.instance;

  Location location = Location();
  late LocationData locationData;
  String _address = '';
  bool showAddress = false;

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

      _address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void getNearbyPlacesContacts(double latitude, double longitude) async {
    String apiKey = "";
    String radius = "10000";

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&keyword=hotel&key=$apiKey');

    var response = await http.post(url);

    NearbyPlacesResponse nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    List<String> placeIds = [];
    nearbyPlacesResponse.results?.forEach((element) {
      placeIds.add(element.placeId.toString());
    });

    for (int i = 0; i < placeIds.length; i++) {
      var url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeIds[i]}&key=$apiKey');

      var response = await http.post(url);

      var data = jsonDecode(response.body);

      if (data.containsKey('result') &&
          data['result'].containsKey('formatted_phone_number')) {
        var contact = data['result']['formatted_phone_number'];

        phoneNumbers.add(contact);
      } else {
        print("No contact found");
      }
    }

    setState(() {});
  }

  void getHelp() {
    getLocation();
    getNearbyPlacesContacts(latitude!, longitude!);
    print(phoneNumbers);
  }

  @override
  void initState() {
    getLocationPermission();
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Container(
          decoration: kBoxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Center(
                    child: Text(
                      'Send Emergency Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: 35,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        getLocation();
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
                              phoneNumbers.forEach((element) {
                                telephony.sendSms(
                                    to: element,
                                    message:
                                        "Sorry, this is a test message by our team for an SOS app that we are currently working on. \nThis is an emergency! My location https://maps.google.com/maps?q=$latitude,$longitude");
                              });

                              // FutureBuilder<
                              //         DocumentSnapshot<Map<String, dynamic>>>(
                              //     future: FirebaseFirestore.instance
                              //         .collection('User')
                              //         .doc(FirebaseAuth
                              //             .instance.currentUser?.email)
                              //         .get(),
                              //     builder: (BuildContext context, dataShots) {
                              //       if (dataShots.connectionState ==
                              //           ConnectionState.waiting) {
                              //         return const Padding(
                              //           padding: EdgeInsets.only(top: 30.0),
                              //           child: CircularProgressIndicator(
                              //             color: Colors.white,
                              //           ),
                              //         );
                              //       }
                              //       if (dataShots.hasData) {
                              //         var myContacts =
                              //             dataShots.data?.get('myContacts');
                              //
                              //         myContacts.forEach((element) {
                              //           print(element);
                              //           telephony.sendSms(
                              //               to: element,
                              //               message:
                              //                   "Please Help... This is an emergency! My location https://maps.google.com/maps?q=$latitude,$longitude");
                              //         });
                              //       }
                              //       return Container();
                              //     });
                            }
                          } else {
                            print("Can't send messages!");
                          }

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
                        width: 180.0,
                        height: 180.0,
                        child: const Center(
                          child: Text(
                            'Help',
                            style: TextStyle(
                                fontSize: 25.0, fontFamily: 'Ubuntu-Medium'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AccountPage()),
                            );
                          },
                        ),
                        const Text(
                          'Note: On clicking this help button we will send your current \nlocation to nearby help and your selected contact members!',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Ubuntu-Medium',
                            fontSize: 11.0,
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
