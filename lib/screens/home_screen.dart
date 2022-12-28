import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:not_alone/components/rounded_button.dart';
import 'package:not_alone/constants.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' hide Location;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location location = Location();
  late LocationData locationData;
  String _address = '';
  double? latitude = 0;
  double? longitude = 0;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Home Screen',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: 35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 150.0,
                    child: RoundedButton(
                        title: 'Help',
                        color: Colors.redAccent,
                        onPressed: () {
                          try {
                            FirebaseFirestore.instance
                                .collection('User')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection('locations')
                                .add({
                              'address': _address,
                              'time': FieldValue.serverTimestamp(),
                            });
                          } catch (e) {
                            print(e);
                          }
                          setState(() {
                            showAddress = true;
                          });
                        },
                        textColor: Colors.white,
                        fontSize: 20),
                  ),
                  Visibility(
                    visible: showAddress,
                    child: Column(
                      children: [
                        Text(_address),
                        Text('Latitude: $latitude, Longitude: $longitude'),
                      ],
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
