import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'Util.dart';
import 'dart:io';
import 'Item.dart';
class Incidence{
   String type;
  //final Location location;
  //final Image image;
  String description;
  //final User user;DateTime date = DateTime.now();
  int status; // 1 -> finalizado / 2 -> em andamento / 3 -> não aceito
  String pathToImage;
  List<Item> items;
  DateTime date;
  Position location;


  Incidence({this.description,this.type,this.status,this.items,this.date,this.pathToImage,this.location}){}

   Map<String,dynamic> toJson() =>{
   'type': this.type,
   'descripton' :   this.description,
   'date':   this.date,
   'status':    this.status,
     'items': this.incidenceToJsonList(),
   'pathToImage':   this.pathToImage,
   'location': this.location.toJson(),
   };

  static Incidence fromJson(Map<String,dynamic> json){
    json['location']['accuracy'] = json['location']['accuracy'] + 0.0;
    json['location']['latitude'] = json['location']['latitude'] + 0.0;
    json['longitude'] = json['location']['longitude'] + 0.0;
    json['location']['speed_accuracy'] = json['location']['speed_accuracy'] + 0.0;
    json['location']['altitude'] = json['location']['altitude'] + 0.0;
    json['location']['heading'] = json['location']['heading'] + 0.0;
    json['location']['speed'] = json['location']['speed'] + 0.0;

    final Incidence aux = new Incidence(
      location: Position.fromMap(json['location']),
      type: json['type'],
      description: json['description'],
      status: json['status'],
      items: Item.fromMap(json['items']),
      pathToImage: json['pathToImage'],
      date: DateTime.fromMicrosecondsSinceEpoch(json['date'].microsecondsSinceEpoch)
    );

    return aux;
  }

   List<Map<String,dynamic>> incidenceToJsonList(){

     List<Map<String,dynamic>> aux = new List<Map<String,dynamic>>();
     this.items.forEach((element) {
       aux.add(element.toJson());
     });
     return aux;
   }

  @override
  String toString() {
    return '{type: $type,'
        'descripton:$description,'
        'date:$date,'
        'status:$status,'
        'items:$items,'
        'pathToImage:$pathToImage,'
        'location:$location}';
  }

}