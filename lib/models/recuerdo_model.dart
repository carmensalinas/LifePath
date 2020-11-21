import 'dart:convert';

RecuerdoModel recuerdoModelFromJson(String str) => RecuerdoModel.fromJson(json.decode(str));

String recuerdoModelToJson(RecuerdoModel data) => json.encode(data.toJson());

class RecuerdoModel {
    RecuerdoModel({
        this.id,
        this.titulo = '',
        this.contenido = '',
        this.ubicacion,
        this.archivado : false,
        this.foto,
    });

    String id;
    String titulo;
    String contenido;
    String ubicacion;
    bool archivado;
    String foto;

    factory RecuerdoModel.fromJson(Map<String, dynamic> json) => RecuerdoModel(
        id: json["id"],
        titulo: json["titulo"],
        contenido: json["contenido"],
        ubicacion: json["ubicacion"],
        archivado: json["archivado"],
        foto: json["foto"],
    );

    Map<String, dynamic> toJson() => {
        // "id": id,
        "titulo": titulo,
        "contenido": contenido,
        "ubicacion": ubicacion,
        "archivado": archivado,
        "foto": foto,
    };
}
