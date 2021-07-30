import 'package:cohatrac_app/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'homepage.dart';

class Notas{
  final int id;
  final String char;
  final String nota;

  Notas({
    this.id,
    this.char,
    this.nota,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'char': char,
      'nota': nota,
    };
  }


  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Notas{id: $id, char: $char, nota: $nota}';
  }
}

class horario {
  final String dia;
  final String abertura;
  final String encerramento;

  horario(this.dia, this.abertura, this.encerramento);

}


class Details extends StatefulWidget {
  final Localidade localidade;
  List<horario> horarios;
  database db = new database();

  Details({Key key, @required this.localidade}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();


}


class _DetailsState extends State<Details> {

  database db = new database();

  void initState() {
    super.initState();
    consultarHorarios(widget.localidade.id, widget.horarios);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
        title:Text ('Notas de ' + widget.localidade.nome),
    ),
    body: Container(

    child: Column(
    children: [
    Center(
    child: CircleAvatar(
    backgroundImage: widget.localidade.image,
    radius: 60,

    ),
    ),
    /*                Container(
                    width: MediaQuery.of(context).size.width/4,
                    height: MediaQuery.of(context).size.height/4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: widget.localidade.image,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),*/


    Text(widget.localidade.nome),
    Text("Endereço:" +widget.localidade.observacao),
    Text("Horários"),

    Center(
      child: FutureBuilder<List>(
      future: db.buscaHorarios(widget.localidade.id), //connectTest(cat),
      builder: (context, snapshot) {
      return snapshot.hasData ? ListView.builder(
        shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (context, int position) {
      final horario hor = horario(snapshot.data[position].dia,
      snapshot.data[position].abertura, snapshot.data[position].encerramento,
      );
      return SafeArea(child: ListTile(
        minVerticalPadding: 0,

      title: Center(child: Text(hor.dia +": " + hor.abertura + " - " + hor.encerramento)),

      )
      );
      }
      )

          : Center(
      child: CircularProgressIndicator(),
      );
      }
      ),
    ),
    

    ]
    )
    )
    );
  }






    }

  Future<void> consultarHorarios(int id, List<horario> horarios) async {
    database db = new database();
    horarios = await db.buscaHorarios(id);
    print("peraearearae");

}
