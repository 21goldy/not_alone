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
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Material(
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
                    const Text(
                      'Add Contact',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat-Bold',
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey.shade400),
                          prefixIcon: Icon(
                            Icons.phone_sharp,
                            color: Colors.grey.shade400,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
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
                        fontSize: 18.0),
                    const SizedBox(
                      height: 50.0,
                    ),
                    const Text(
                      'My Contacts: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('User')
                            .doc(FirebaseAuth.instance.currentUser?.email)
                            .get(),
                        builder: (BuildContext context, dataShots) {
                          if (dataShots.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 30.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
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
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('User')
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.email)
                                          .update({
                                        'myContacts':
                                            FieldValue.arrayRemove([i]),
                                      });
                                      setState(() {});
                                    },
                                  )
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
      ),
    );
  }
}
