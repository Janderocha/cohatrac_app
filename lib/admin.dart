import 'package:cohatrac_app/database.dart';
import 'package:cohatrac_app/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';



// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String nome, email, celular;
database db = new database();
List<Categoria> categorias;
String dropdownValue = 'two';
  @override
  Widget build(BuildContext context)  {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
        ),
        backgroundColor: Colors.lightBlue,
        title: Text("Adicionar novo estabelecimento"),
      ),

    body:Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: new InputDecoration(hintText: "Nome do estabelecimento"),
            maxLength: 30,

            onSaved: (String val) {
              nome = val;
            }


          ),TextFormField(
            decoration: new InputDecoration(hintText: "Breve Descricao"),
            maxLength: 30,

            onSaved: (String descricao) {
              email = descricao;
            }          ),

      DropdownButtonFormField<String>(
          value: "dropdownValue",
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: []
          ),
          TextFormField(
            decoration: new InputDecoration(hintText: "Breve Descricao"),
            maxLength: 30,

            onSaved: (String descricao) {
              email = descricao;
            }


          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.

              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    )
    );
  }
}
