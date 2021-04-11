import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Incidence.dart';

class IncidenceDetail extends StatelessWidget {
  const IncidenceDetail(this.item);
  final Incidence item;
  @override
  Widget build(BuildContext context) {
    String text;
    Icon icon;
    if (item.status == 1) {
      text = 'Aprovado, muito obrigado pela ajuda!';
      icon = Icon(
        Icons.emoji_events,
        color: Colors.yellow,
      );
    } else if (item.status == 2) {
      text = 'Em andamento';
      icon = Icon(
        Icons.timelapse,
        color: Colors.indigo,
      );
    } else {
      text = 'Incidência incorreta';
      icon = Icon(
        Icons.sentiment_dissatisfied_sharp,
        color: Colors.indigo,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        backgroundColor: Colors.indigo,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text('DATA'),
              Text(item.date.toString()),
              SizedBox(height: 50,),
              Text('TIPO'),
              Text(item.type),
              SizedBox(height: 50,),
              Text('DESCRICAO'),
              Text(item.description),
              SizedBox(height: 50,),
              Text('STATUS'),
              Text(text),
              icon
            ],
          ),
        ],
      ),
    );
  }
}
