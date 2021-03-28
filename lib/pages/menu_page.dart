
import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Elemento.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu',
      home: Scaffold(
        body: Container(
        ),
        appBar: AppBar(
          title: Text(
            'Perfil'
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.star),
              onPressed: (){},
            ),
          ],
          centerTitle: true,
        ),
        drawer: Drawer(

          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Minhas incidências'
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondRoute()));
                },
              ),
              ListTile(
                title: Text(
                  'Adicionar uma incidência'
                ),
                onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FirstRoute()));
                },
              ),
            ],
          ),

        ),
      ),
    );
}
}

class FirstRoute extends StatelessWidget {

  final elementos = List<Elemento>.generate(20, (index) => Elemento(
    '$index',
    'aaaa'
  ),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: ListView(//Lista que da para dar scroll
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
  const Element({//construtor
    Key key,
    this.title,
    this.subTitle
  }) : super(key: key);
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.star),
      trailing: Icon(Icons.ac_unit_rounded),
      title: Text(title),
      subtitle: Text(subTitle)
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),

      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

//MainAxisAlignment -> para alinhas em um widget