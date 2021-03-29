import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Elemento.dart';

class IncidencesList extends StatelessWidget {
  final elementos = List<Elemento>.generate(
    20,
        (index) => Elemento('$index', 'aaaa'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suas Incidências'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          //Lista que da para dar scroll
          children: [
            Element(
              title: 'titulo',
              subTitle: 'subTitulo',
            ),
            ListTile(
              title: Text('Segundo Elemento'),
            ),
            ListTile(
              title: Text('Terceiro Elemento'),
            ),
            Container(
              height: 50,
              color: Colors.red,
            ),
            Container(
              height: 50,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class Element extends StatelessWidget {
  const Element(
      { //construtor
        Key key,
        this.title,
        this.subTitle})
      : super(key: key);
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.star),
        trailing: Icon(Icons.ac_unit_rounded),
        title: Text(title),
        subtitle: Text(subTitle));
  }
}

