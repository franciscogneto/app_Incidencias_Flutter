import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'User.dart';

class Incidence{
  final String type;
  //final Location location;
  //final Image image;
  final String description;
  //final User user;
  final DateTime date = DateTime.now();

  Incidence(this.description,this.type){}
}