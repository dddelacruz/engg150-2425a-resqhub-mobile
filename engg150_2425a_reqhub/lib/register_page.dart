import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterForm extends StatefulWidget{
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>{
  final genderOptions = ["Male", "Female"];

  @override
  Widget build(BuildContext context){
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: Column(
          children: <Widget>[
            FormBuilder(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderTextField(
                        name: "firstName",
                        decoration: InputDecoration(
                          labelText: "First Name",
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderTextField(
                        name: "middleName",
                        decoration: InputDecoration(
                          labelText: "Middle Name",
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FormBuilderTextField(
                        name: "lastName",
                        decoration: InputDecoration(
                          labelText: "Last Name",
                        ),
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
                      child: FormBuilderDateRangePicker(
                        name: "birthday", 
                        firstDate: DateTime(1970), 
                        lastDate: DateTime(2030),
                        decoration: InputDecoration(
                          labelText: "Date of Birth",
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => {}, 
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