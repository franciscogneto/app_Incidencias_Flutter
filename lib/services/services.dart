import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:incidencias_app/models/Incidence.dart';
import 'package:incidencias_app/models/Util.dart';
import 'dart:io';

class services {
  ///It takes Take the document from firestore by user email
  Future<DocumentSnapshot> getDocumentFromUserByEmail(String email) async {
    DocumentSnapshot aux;
    await FirebaseFirestore.instance.collection('User').doc(email).get().then((value) { aux = value;});
    return aux;
  }

  ///It takes the document from the firestore by user email and tronsform to Util Object
  Future<Util> getUtilDataFromUserByEmail(String email) async {
    Util data;
    await FirebaseFirestore.instance.collection('User').doc(email).get().then((value) { data = Util.fromJson(value.data()); });
    return data;
  }

  ///It returns the incidences's count from a user by its email
  Future<int> getCountIncidentesByEmail(String email) async {
    DocumentSnapshot map;
    await FirebaseFirestore.instance.collection('User').doc(email).get().then((value) { map = value;});
    Util data = Util.fromJson(map.data());
    return data.incidences.length;
  }
  ///It adds a new incidence to a user by his id and returns the status
  Future<String> addIncidenceByEmail(Incidence data,String email, File photo, String path) async{
    String aux;
    Util toUpdate;
    await this.getUtilDataFromUserByEmail(email).then((value) => toUpdate = value);
    print(toUpdate);
    toUpdate.addIncidente(data);
    await FirebaseFirestore.instance.collection('User').doc(email).set(toUpdate.toJson()).then((value) => aux = '').catchError(() => aux = 'Error, please try again');
    if(aux == ''){
      await FirebaseStorage.instance.ref(path).putFile(photo).then((value) {
        if(value.bytesTransferred != 0)
          aux = 'image uploaded';
        else
          aux = 'fail to upload the photo, please try again';
      });
    }
    return aux;
  }




}