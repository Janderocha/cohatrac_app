import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:path/path.dart';
import 'details.dart';

class Config extends StatefulWidget {
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  double _initvalue = 2000.0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
        ),
        elevation: 0,
        title: Text(
          'Configurações',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: Column(children: [
          Text('Distancia:' + (_initvalue / 1000).round().toString() + ' km'),
          Slider(
              value: _initvalue.toDouble(),
              min: 0.0,
              max: 100000.0,
              divisions: 200,
              inactiveColor: Colors.grey,
              activeColor: Colors.cyan,
              onChanged: (double newValue) {
                setState(() {
                  _initvalue = newValue;
                });
              }),
          ElevatedButton(
            child: Text('Confirmar'),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home',
                  arguments: {'distancia': _initvalue});
            },

          )
        ]),
      ),
    );
  }
}
