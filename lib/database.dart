import 'dart:async';
import 'dart:convert' ;
import 'package:cohatrac_app/details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'dart:typed_data';
import 'utils.dart';
class database{
Future <PostgreSQLConnection>connect() async {
  String url = "10.0.2.2";
  int port = 5432;
  String db = "postgres";
  String username = "postgres";
  String pass = "postgres";

  var connection = PostgreSQLConnection(
      url, port, db, username: username, password: pass);
  await connection.open();
  return connection;
}

Future<List> buscaEstabelecimentos(int cat) async {
  var connection = await connect();
  List<List<dynamic>> results = await connection.query(
      "SELECT * FROM estabelecimento"
          " WHERE "
          "categoria = @aCat",
      substitutionValues: {

        "aCat": cat
      }
  );
  return results;
}

Future<List> buscaTodosEstabelecimentos() async {
  var connection = await connect();
  List<List<dynamic>> results = await connection.query(
      "SELECT * FROM estabelecimento"

  );
  return results;
}


Future<List> buscaTodasCategorias() async {
  var connection = await connect();
  List<List<dynamic>> results = await connection.query(
      "SELECT categoria FROM estabelecimento"

  );
  return results;
}

Future<List> buscaHorarios(int estabelecimento) async {
  var connection = await connect();
  List<List<dynamic>> results = await connection.query(
      "SELECT  dia, abertura, duracao FROM horarios "
          "WHERE estabelecimento = @aEst", substitutionValues: {
        "aEst":estabelecimento,
  }


  );

  List<horario> horarios = [];
  for (final dynamic r in results){
    String dia = semana.values[int.parse(r[0])].toString() ;
    String diaFormatado = dia.toString().substring(dia.toString().indexOf('.') + 1);
    DateTime now = DateTime.now();
    DateTime _inicio = DateTime(now.year, now.month, now.day, int.parse(r[1].split(":")[0]), int.parse(r[1].split(":")[1]));
    Duration _duracao = new Duration(hours:int.parse(r[2].split(":")[0]), minutes: int.parse(r[2].split(":")[1]));
    DateTime _encerramento = _inicio.add(_duracao);
    horario hor = horario(diaFormatado, DateFormat('kk:mm').format(_inicio),  DateFormat('kk:mm').format(_encerramento));


    horarios.add(hor);


    print("start: " + _inicio.toString());
    print("duracao: " + _duracao.toString());
    print("fim: " + _encerramento.toString());
  }
  return horarios;
}


}