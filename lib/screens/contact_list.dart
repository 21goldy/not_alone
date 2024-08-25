import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:not_alone/components/rounded_button.dart';
import 'package:not_alone/constants.dart';

String number = '';
int countOfContacts = 0;

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  bool showSpinner = false;
  TextEditingController addController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fetching screen size
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Container(
            decoration: kBoxDecoration,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Contact',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat-Bold',
                      fontSize: screenHeight * 0.04,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: TextFormField(
                      controller: addController,
                      onChanged: (value) {
                        number = value;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Ex: 1234...',
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade400,
                          fontSize: screenHeight * 0.02,
                        ),
                        prefixIcon: Icon(
                          Icons.phone_sharp,
                          color: Colors.grey.shade400,
                          size: screenHeight * 0.03,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(screenHeight * 0.02),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  RoundedButton(
                    title: 'Add',
                    color: Colors.white,
                    onPressed: () {
                      addController.clear();
                      if (countOfContacts < 3) {
                        setState(() {
                          showSpinner = true;
                        });

                        FirebaseFirestore.instance
                            .collection('User')
                            .doc(FirebaseAuth.instance.currentUser?.email)
                            .update({
                          'myContacts': FieldValue.arrayUnion([number]),
                        });
                        setState(() {
                          showSpinner = false;
                        });
                      } else {
                        print('You cannot add more than 3 contacts');
                      }
                    },
                    fontSize: screenHeight * 0.025,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Text(
                    'My Contacts: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * 0.03,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('User')
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .get(),
                      builder: (BuildContext context, dataShots) {
                        if (dataShots.connectionState == ConnectionState.waiting) {
                          return Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.03),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: screenHeight * 0.005,
                            ),
                          );
                        }
                        if (dataShots.hasData) {
                          List<Widget> number = [];
                          var x = dataShots.data?.get('myContacts');
                          countOfContacts = x.length;

                          for (var i in x) {
                            number.add(Row(
                              children: [
                                Text(
                                  i,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenHeight * 0.020,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: screenHeight * 0.025,
                                  ),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(FirebaseAuth.instance.currentUser?.email)
                                        .update({
                                      'myContacts': FieldValue.arrayRemove([i]),
                                    });
                                    setState(() {});
                                  },
                                ),
                              ],
                            ));
                          }

                          return Column(
                            children: number,
                          );
                        }

                        return const Text('Not working!');
                      },
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
