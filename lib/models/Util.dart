import 'dart:convert';

import 'package:incidencias_app/models/Incidence.dart';
import 'package:intl/intl.dart';


class Util{

  DateTime creationData;

  List<Incidence> incidences = new List<Incidence>();

  Util();

  addIncidente(Incidence incidence){
    incidences.add(incidence);
  }

  Map<String,dynamic> toJson() =>{
    'creationData':this.creationData,
    'incidences': this._incidenceToJsonList()
  };

  static Util fromJson(Map<String,dynamic> json) {
    final List<dynamic> teste = json['incidences'];
    int tt = 0;
    final Util data = new Util();
    teste.forEach((element) {
      Incidence aaa = Incidence.fromJson(element);
      data.addIncidente(aaa);
    });

    if(json['creationData'] != null)
      data.creationData = DateTime.parse(json['creationData']);
    else
      data.creationData = null;

    return data;
  }

List<Map<String,dynamic>> _incidenceToJsonList(){
    List<Map<String,dynamic>> aux = new List<Map<String,dynamic>>();
    this.incidences.forEach((element) {
      aux.add(element.toJson());
    });
    return aux;
    }

}