import 'package:flutter/material.dart';
import 'package:flutter_vscode/models/recuerdo_model.dart';
import 'package:flutter_vscode/providers/recuerdos_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final recuerdosProvider = new RecuerdosProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuerdos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _crearListado(),
          ),
          Row(
            children: [
              IconButton(
                  iconSize: 40.0,
                  color: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 29.0),
                  icon: Icon(Icons.add_box),
                  onPressed: () {
                    Navigator.pushNamed(context, 'recuerdo').then((val) {
                      setState(() {});
                    });
                  }),
              IconButton(
                  iconSize: 40.0,
                  color: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 29.0),
                  icon: Icon(Icons.camera_alt),
                  onPressed: null),
              IconButton(
                  iconSize: 40.0,
                  color: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 29.0),
                  icon: Icon(Icons.location_on),
                  onPressed: null),
              IconButton(
                  iconSize: 40.0,
                  color: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 29.0),
                  icon: Icon(Icons.search),
                  onPressed: null),
            ],
          )
        ],
      ),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: recuerdosProvider.cargarRecuerdos(),
      builder:
          (BuildContext context, AsyncSnapshot<List<RecuerdoModel>> snapshot) {
        if (snapshot.hasData) {
          final recuerdos = snapshot.data;
          return ListView.builder(
            itemCount: recuerdos.length,
            itemBuilder: (context, i) =>
                _crearRecuerdo(context, recuerdos[i], recuerdos),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _crearRecuerdo(BuildContext context, RecuerdoModel recuerdo,
      List<RecuerdoModel> recuerdos) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.amber[900]),
        onDismissed: (direccion) async {
          print(direccion);
          await recuerdosProvider.borrarProducto(recuerdo.id);
          recuerdos.remove(recuerdo);
        },
        child: Card(
            child: Column(
          children: [
            Container(
                // boundaryMargin: EdgeInsets.all(20.0),
                // minScale: 0.1,
                // maxScale: 1.6,
                child: (recuerdo.foto == null)
                    ? Container()
                    : FadeInImage(
                        placeholder: AssetImage('assets/jar-loading.gif'),
                        image: NetworkImage(recuerdo.foto),
                        height: 300.0,
                        width: double.infinity,
                        fit: BoxFit.cover)),
            ListTile(
                title: Text('${recuerdo.titulo}'),
                subtitle: Text('${recuerdo.contenido}'),
                onTap: () => Navigator.pushNamed(context, 'recuerdo',
                            arguments: recuerdo)
                        .then((val) {
                      setState(() {});
                    }))
          ],
        )));
  }
}
