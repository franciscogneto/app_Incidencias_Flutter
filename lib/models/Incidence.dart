import 'User.dart';

class Incidence{
  final String type;
  //final Location location;
  //final Image image;
  final String description;
  //final User user;
  final DateTime date = DateTime.now();
  final int status; // 1 -> finalizado / 2 -> em andamento / 3 -> não aceito

  Incidence({this.description,this.type,this.status}){}
}