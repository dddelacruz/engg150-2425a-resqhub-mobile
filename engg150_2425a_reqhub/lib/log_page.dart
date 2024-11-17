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

                          // add new log to log database

                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "New User Registered and Logged In",
                          );

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