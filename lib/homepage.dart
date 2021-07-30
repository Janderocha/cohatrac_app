import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geolocator/geolocator.dart';
import 'package:postgres/postgres.dart';

import 'config.dart';
import 'details.dart';
import 'database.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
// TODO: implement createState
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}


class Localidade{
  final int id;
  final String nome;
  final String observacao;
  final int categoria;
  final MemoryImage image;


  Localidade(this.id, this.nome, this.observacao, this.categoria, this.image);

}

class Categoria{
  final String nome;
  final String descricao;

  Categoria(this.nome, this.descricao);

}

Future <List>connectTest(var cat) async{
  String url = "10.0.2.2";
  int port = 5432;
  String db = "postgres";
  String username = "postgres";
  String pass = "postgres";

  var connection = PostgreSQLConnection(url, port, db, username: username, password: pass);
  await connection.open();
  List<List<dynamic>> results = await connection.query("SELECT * FROM estabelecimento"
      " WHERE "
      //"id = @aValue AND
    "categoria = @aCat", substitutionValues: {
  //  "aValue" : 2,
    "aCat" : cat
  }

  );
  print ("passou");

  print("retorno?");
  return results;
}
class _HomePageState extends State<HomePage> {

/*
  void _onItemTap(int index) {
    setState() {
      if (index == 0) {
        Navigator.of(context).pushReplacementNamed('/home');
        print(index);
      } else if (index == 1) {
        Navigator.of(context).pushReplacementNamed('/todas');
        print(index);
      }
    }
  }*/

  List<String> images = [
    'https://images.unsplash.com/photo-1494500764479-0c8f2919a3d8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1350&q=80',
    'https://www.rcsdk8.org/sites/main/files/main-images/camera_lense_0.jpeg',
    'https://images.unsplash.com/photo-1494500764479-0c8f2919a3d8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1350&q=80'
  ];
  database db = new database();
  int cat;
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute
        .of(context)
        .settings
        .arguments as Map;
    double dist;
    if (arguments != null) {
      dist = arguments['distancia'];
      if (cat == null)
      cat = arguments['categoria'];
    }
    return Scaffold(
      drawer: Drawer(

        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Filtrar por Categoria'),
            ),
            ListTile(
              title: Text('Igrejas'),
              onTap: () {
                cat = 1;
                setState(() {

                  Navigator.pop(context);
                });
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Supermercados'),
              onTap: () {
                cat = 2;
                Navigator.pop(context);
                // Update the state of the app.
                // ...
              },
            ),ListTile(
              title: Text('Admin'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/admin');
              //  Navigator.pop(context);
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
        ),
        backgroundColor: Colors.lightBlue,

      elevation: 0,
/*       leading: IconButton(
          icon: Icon(Icons.settings),
          color: Colors.black,
         //   onPressed: () => Navigator.of(context).pushNamed('/confs'),
        ),*/
        title: Text('Mostrando Eventos em até ' + (dist / 1000).round().toString() + 'km',
          style: TextStyle(
            color: Colors.black,
          ),),
      ),

      body: FutureBuilder<List>(
       future: db.buscaEstabelecimentos(cat), //connectTest(cat),
        builder: (context, snapshot) {
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, int position) {

                final Localidade local = Localidade(snapshot.data[position][0],
                    snapshot.data[position][1], snapshot.data[position][2],
                    snapshot.data[position][3],
                    MemoryImage(snapshot.data[position][5]));

              print (local.nome);
              //get your item data here ...
              return GestureDetector(
                  onTap: () async {
                if (local.nome != "Todas as notas") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(localidade:local,
                    ),
                  )
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Config()),
                  );
                }
              },
              child:ListTile(

              title:Text(local.nome),
              subtitle: Text(local.observacao),
                    leading: CircleAvatar(
                        backgroundImage:
                       local.image,
                    )));


            }
          )
           :    Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

    );
  }
}




/*
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed('/confs');
                });

                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
    );
  }*/


Localidade _localidade;





/*
class Opcao {
  final String titulo;
  final String nome;
  final String end;
  final double lat;
  final double long;
  final DateTime openTime;
  final DateTime closeTime;
  final String imageUrl;

  const Opcao(this.titulo, this.nome, this.end, this.lat, this.long,
      this.openTime, this.closeTime, this.imageUrl);
}

List<Opcao> opcoes = <Opcao>[
*/
/*  Opcao(
    "velhooesteslz",
    "Velho Oeste Saloon",
    "R. Pernambuco, 707 - Chácara Brasil, São Luís - MA, 65066-851",
    -2.5049561167585703,
    -44.218366803247186,
    DateTime(DateTime
        .now()
        .year, DateTime
        .now()
        .month, DateTime
        .now()
        .day, 18, 0),
    DateTime(DateTime
        .now()
        .year, DateTime
        .now()
        .month, DateTime
        .now()
        .day, 23, 0),
  ),*//*

  Opcao(
      "botecodapinga",
      "Boteco da Pinga",
      "364, R. Uberlândia, 180 - Parque Atlantico, São Luís - MA",
      -2.4868965296111583,
      -44.24239897441146,
      DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 18, 0),
      DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 23, 0),
      'https://scontent-ort2-2.cdninstagram.com/v/t51.2885-19/140470253_3826873410696797_5029562869362431857_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com&_nc_ohc=3oq5zukToi8AX8XnK_6&edm=AKralEIBAAAA&ccb=7-4&oh=22bbc063d68e905e49f1da23121598e1&oe=60DDC8BE&_nc_sid=5e3072'),
  Opcao(
      "md.saoluisma",
      "Mad Dwarf slz",
      "bandeira plaza - Av. dos Holandeses, 200 - LOJA 01 - Olho D'agua, São Luís - MA, 65065-180",
      -2.490869543779471,
      -44.23467904742619,
      DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 18, 0),
      DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 23, 0),
      'https://scontent-atl3-2.cdninstagram.com/v/t51.2885-19/70767297_350642255691828_4340414775910465536_n.jpg?_nc_ht=scontent-atl3-2.cdninstagram.com&_nc_ohc=cLNPrxpRFcAAX_OkMQR&edm=AKralEIBAAAA&ccb=7-4&oh=a2165df0ea53f604e1543bb7bed84102&oe=60DCFD5E&_nc_sid=5e3072'
  ),
  Opcao(
      "botecodoretornooficial",
      "Boteco e Espetaria do Retorno",
      "Av. Contôrno Norte Sul, 47 - Cohatrac, São Luís - MA, 65054-380",
      -2.5388572052888043,
      -44.20220946276906,
      DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 18, 0),
      DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 23, 0),
      'https://scontent-ort2-2.cdninstagram.com/v/t51.2885-19/69384868_944608365902392_936338432857210880_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com&_nc_ohc=obTvTTnc9cIAX9zq1Yx&edm=AKralEIBAAAA&ccb=7-4&oh=1ddcef835b6606876e1cfb0ea0fcd8f6&oe=60DCF877&_nc_sid=5e3072'),
  Opcao(
      "conchasbar_e_restaurante",
      "Conchas Bar e Restaurante",
      "Av. Litorânea, 17 B - Quintas do Calhau, São Luís - MA, 65071-377",
      -2.4828142853978057, -44.25702943023278,
      DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 8, 0),
      DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day+1, 2, 0),
      "https://scontent-ort2-2.cdninstagram.com/v/t51.2885-19/76861125_458393368162894_4143453348151951360_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com&_nc_ohc=3zymbkMiD08AX-X3uD7&edm=AKralEIBAAAA&ccb=7-4&oh=559daf5f873c6dff01a5f988311ae994&oe=60DCC12B&_nc_sid=5e3072"),
  Opcao(
      "luabistro",
      "Lua Bistrô",
      "Av. Dom Pedro II - Centro Histórico de - Centro, São Luís - MA, 65000-000",
      -2.527930422243255, -44.30497376091871,
      DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 11, 30),
      DateTime(DateTime
          .now()
          .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day, 14, 15),
      "https://scontent-ort2-1.cdninstagram.com/v/t51.2885-19/101301084_822499878274584_4869145556653441024_n.jpg?_nc_ht=scontent-ort2-1.cdninstagram.com&_nc_ohc=B9w93yZus1cAX9dEpNY&edm=AKralEIBAAAA&ccb=7-4&oh=25719f587280e45803ebcd21c7a26165&oe=60DD9259&_nc_sid=5e3072")];
*/


/*
Future<Position> buscaOpcoes(Opcao o, double distancia) async {
  Future<Position> retorno;

  final DateTime currentTime = DateTime.now();
  if (currentTime.isAfter(o.openTime) && currentTime.isBefore(o.closeTime)) {
    Position location = await Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
    double distance = Geolocator.distanceBetween(
        location.latitude, location.longitude, o.lat, o.long);
    print(distance.toString());
    if (distance <= distancia) {
      retorno =  Geolocator.getCurrentPosition();
    } else {
      retorno = null;
    }
  }
  return retorno;
}
*/


/*
class OpcaoCard extends StatelessWidget {
  const OpcaoCard({Key key, this.opcao, this.distancia}) : super(key: key);
  final Opcao opcao;
  final double distancia;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (this.opcao.titulo != "Todas as notas") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(localidade,: this.localidade: ,),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Config()),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: FutureBuilder<Position>(
                future: buscaOpcoes(opcao, distancia),
                builder: (BuildContext context,
                    AsyncSnapshot<Position> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          NetworkImage(opcao.imageUrl),
                          scale: 0.5,
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      child: Text(snapshot.data.longitude.toString() +  snapshot.data.latitude.toString()),
                    );
                  } else {
                    return Column(
                        children: [
                          Image.network(opcao.imageUrl),
                          Text(opcao.titulo),]
                    );


                  }
                })),
      ),
    );
  }

// TODO: implement build
}*/
