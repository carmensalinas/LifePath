import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vscode/models/recuerdo_model.dart';
import 'package:flutter_vscode/providers/recuerdos_provider.dart';
import 'package:image_picker/image_picker.dart';

class RecuerdoPage extends StatefulWidget {
  RecuerdoPage({Key key}) : super(key: key);

  @override
  _RecuerdoPageState createState() => _RecuerdoPageState();
}

class _RecuerdoPageState extends State<RecuerdoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final recuerdosProvider = new RecuerdosProvider();

  RecuerdoModel recuerdo = new RecuerdoModel();

  bool _guardando = false;
  PickedFile photo;

  @override
  Widget build(BuildContext context) {
    final RecuerdoModel recData = ModalRoute.of(context).settings.arguments;
    if (recData != null) {
      recuerdo = recData;
    }

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Nuevo recuerdo'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.location_on), onPressed: _getUbicacion),
            IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto,
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _tomarFoto,
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _mostrarFoto(),
                  _crearTitulo(),
                  _crearContenido(),
                  _crearBtn()
                ],
              )),
        )));
  }

  Widget _crearTitulo() {
    return TextFormField(
      initialValue: recuerdo.titulo,
      autofocus: true,
      decoration: InputDecoration(labelText: 'título'),
      onSaved: (value) => recuerdo.titulo = value,
      validator: (value) {
        return value.length < 4
            ? "Escribe por lo menos una palabra para que sepas de qué se trata :D"
            : null;
      },
    );
  }

  Widget _crearContenido() {
    return TextFormField(
      initialValue: recuerdo.contenido,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(labelText: 'contenido'),
      onSaved: (value) => recuerdo.contenido = value,
    );
  }

  Widget _crearBtn() {
    String boton = recuerdo.id != null ? 'Actualizar' : 'Guardar';
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        textColor: Colors.white,
        color: Colors.brown,
        onPressed: _guardando ? null : _submit,
        icon: Icon(Icons.save),
        label: Text(boton));
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (photo != null) {
      String url = await recuerdosProvider.subirImagen(File(photo.path));
      recuerdo.foto = url;
    }

    if (recuerdo.id != null) {
      await recuerdosProvider.editarRecuerdo(recuerdo);
      Navigator.pop(context);
    } else {
      await recuerdosProvider.crearRecuerdo(recuerdo);
      Navigator.pop(context);
      // mostrarSnackBar('Guardado correctamente');
    }
  }

  _mostrarFoto() {
    if (recuerdo.foto != null) {
      return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(recuerdo.foto),
          height: 300.0,
          fit: BoxFit.cover);
    } else {
      if (photo != null) {
        final imagefile = File(photo.path);
        return Image.file(
          imagefile,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Container();
    }
  }

  _seleccionarFoto() async {
    _processImage(ImageSource.gallery);
  }

  _tomarFoto() async {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource type) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: type,
    );

    // Para manejar el error al cancelar la seleccion de una foto
    try {
      photo = PickedFile(pickedFile.path);
    } catch (e) {
      print('$e');
    }

    // Si el usuario cancelo o no selecciona una foto
    if (photo != null) {
      recuerdo.foto = null;
      // limpieza
      // product.urlImg = null;
    }

    setState(() {});
  }

  void _getUbicacion() {}

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      backgroundColor: Colors.amber,
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
