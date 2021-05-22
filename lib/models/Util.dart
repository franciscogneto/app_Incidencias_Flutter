import 'package:incidencias_app/models/Incidence.dart';


class User{

  DateTime CreationData;
  //String ra;
  //String pathToImage;
  List<Incidence> incidences;

  User(this.CreationData);

  addIncidente(Incidence incidence){
    incidences.add(incidence);
  }

  Map<String,dynamic> toJson() =>{
    'CreationData':this.CreationData,
    ''
  };

}