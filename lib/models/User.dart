import 'package:incidencias_app/models/Incidence.dart';


class User{
  final String email;
  String name;
  String ra;
  String pathToImage;
  List<Incidence> incidences;

  User(this.email);

  addIncidente(Incidence incidence){
    incidences.add(incidence);
  }


}