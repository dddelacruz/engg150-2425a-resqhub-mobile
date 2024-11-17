import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';


class LogInOutForm extends StatefulWidget{
  const LogInOutForm({super.key});

  @override
  State<LogInOutForm> createState() => _LogInOutFormState();
}

class _LogInOutFormState extends State<LogInOutForm>{
  final _formKey = GlobalKey<FormBuilderState>();
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: Column(
          children: <Widget>[
            FormBuilder(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState!.save();
                  log(_formKey.currentState!.value.toString());
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderTextField(
                        name: "fName",
                        decoration: InputDecoration(
                          labelText: "First Name",
                        ),
                        valueTransformer: (value) => value?.toUpperCase(),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderTextField(
                        name: "mName",
                        decoration: InputDecoration(
                          labelText: "Middle Name",
                        ),
                        valueTransformer: (value) => value?.toUpperCase(),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderTextField(
                        name: "lName",
                        decoration: InputDecoration(
                          labelText: "Last Name",
                        ),
                        valueTransformer: (value) => value?.toUpperCase(),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint(_formKey.currentState?.value.toString());
                          
                          if(_formKey.currentState != null){
                            var name = {
                              "fName" : _formKey.currentState!.value["fName"],
                              "mName" : _formKey.currentState!.value["mName"],
                              "lName" : _formKey.currentState!.value["lName"],
                            };

                            // find id of user
                            var id ="";
                            var loggingOut = false;

                            db.collection("users").where("fName", isEqualTo: name["fName"])
                              .where("mName", isEqualTo: name["mName"])
                              .where("lName", isEqualTo: name["lName"])
                              .get().then((querySnapshot){
                                for (var docSnapshot in querySnapshot.docs) {
                                  log("found match");
                                  id = docSnapshot.id;
                                  
                                  log("User id: $id");

                                  // check if user is logged in or not
                                  db.collection("logs").where("id", isEqualTo: id).get().then((querySnapshot){
                                    for (var docSnapshot in querySnapshot.docs) {
                                      log('${docSnapshot.id} => ${docSnapshot.data()}');
                                      if(docSnapshot.data()['timeOut'] == null){
                                        log("logging out");
                                        loggingOut = true;

                                        db.collection("logs").doc(docSnapshot.id).set({"timeOut" : DateTime.now()}, SetOptions(merge: true)).then((_){
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.success,
                                            text: "User Logged Out",
                                          );
                                        });

                                        break;
                                      }
                                    }

                                    // user is logging in
                                    if(!loggingOut){
                                      log("logging in");
                                      // add to firebase
                                      final newlog = <String, dynamic>{
                                        "id": id,
                                        "timeIn": DateTime.now(),
                                        "timeOut": null,
                                      };

                                      db.collection("logs").add(newlog).then((DocumentReference doc) {
                                        log('DocumentSnapshot added with ID: ${doc.id}');
                                        
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text: "User Logged In",
                                        );
                                     });
                                    }
                                  });

                                  break;
                                }
                              });

                          }

                        }, 
                        child: const Text("Submit")),
                    )
                  ],
                ),
              ),
          ],
        ),
      )
    );
  }
}