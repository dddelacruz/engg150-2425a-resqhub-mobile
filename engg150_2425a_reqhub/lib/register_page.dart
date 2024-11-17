import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';


class RegisterForm extends StatefulWidget{
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>{
  final genderOptions = ["Male", "Female"];
  final _formKey = GlobalKey<FormBuilderState>();
  final db = FirebaseFirestore.instance;

  var data = {
    "fName" : "",
    "lName" : "",
    "mName" : "",
    "DOB" : "",
    "sex" : "",
  };

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
                      child: FormBuilderDropdown(
                        name: "sex", 
                        items: genderOptions
                        .map((gender) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: gender,
                              child: Text(gender),
                            ))
                          .toList(),
                        decoration: InputDecoration(
                          labelText: "Gender",
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderDateTimePicker(
                        name: "DOB", 
                        initialDate: DateTime.now(),
                        inputType: InputType.date,
                        decoration: InputDecoration(
                          labelText: "Date of Birth",
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint(_formKey.currentState?.value.toString());

                          // add to users database
                          log("adding user to database");
                          db.collection("users").add(_formKey.currentState!.value).then((DocumentReference doc) =>
                            log('DocumentSnapshot added with ID: ${doc.id}'));

                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "New User Registered",
                          );

                          // add new log to log database
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