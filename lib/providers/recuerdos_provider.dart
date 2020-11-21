import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_vscode/models/recuerdo_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class RecuerdosProvider {
  final String _url = 'https://lifepath-6a6e1.firebaseio.com';

  Future<String> crearRecuerdo(RecuerdoModel recuerdo) async {
    final url = '$_url/recuerdos.json';
    final response = await http.post(url, body: recuerdoModelToJson(recuerdo));
    final decodedData = json.decode(response.body);
    return decodedData['name'];
  }

  Future<bool> editarRecuerdo(RecuerdoModel recuerdo) async {
    final url = '$_url/recuerdos/${recuerdo.id}.json';
    try {
      final response = await http.put(url, body: recuerdoModelToJson(recuerdo));
      final decodedData = json.decode(response.body);
      print(decodedData);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<RecuerdoModel>> cargarRecuerdos() async {
    final url = '$_url/recuerdos.json';
    final response = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(response.body);
    if (decodedData == null) return [];

    final List<RecuerdoModel> recuerdos = new List();
    decodedData.forEach((id, recuerdo) {
      final recTemp = RecuerdoModel.fromJson(recuerdo);
      recTemp.id = id;
      recuerdos.add(recTemp);
    });
    return recuerdos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/recuerdos/$id.json';
    await http.delete(url);
    return 1;
  }

  Future<String> subirImagen(File imagen) async {
    var uniqueId = DateTime.now().millisecondsSinceEpoch;
    final url =
        Uri.parse('https://lifepath-backend.vercel.app/picture/$uniqueId');
    final mimeType = mime(imagen.path).split('/');

    final sendImg = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('img', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    sendImg.files.add(file);

    final response = await sendImg.send();

    final resp = await http.Response.fromStream(response);

    final urlData = json.decode(resp.body);

    return urlData['url'];
  }
}
