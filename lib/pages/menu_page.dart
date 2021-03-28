import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Elemento.dart';

class MenuPage extends StatelessWidget {
  final Colorblue = Colors.indigo;
  final String image =
      'https://conteudo.imguol.com.br/c/entretenimento/13/2017/09/20/marcos-o-vin-diesel-brasileiro-1505924753054_v2_900x506.jpg.webp';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu',
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.75,
              decoration: BoxDecoration(
                color: Colorblue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, //incidencias / imagem / em aberto
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Incidencias',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '12',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 175,
                          width: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(image),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'em aberto',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '12',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'RA: XXXXX',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 40,
                          bottom: 30,
                        ),
                        child: Text(
                          'Vin Diesel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.emoji_events_rounded,
                          color: Colors.yellow,
                          size: 75,
                        ),
                        Text(
                          '6/10',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 25,left: 25),
                      child: Column(
                        children: <Widget>[
                          Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colorblue,
                              ),
                              child: IconButton(
                                  icon: Icon(Icons.list),
                                  color: Colors.white,
                                  iconSize: 75,
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => FirstRoute()));
                                  }),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 25),
                            child: Column(

                              children: <Widget>[

                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                    color: Colorblue,
                                  ),
                                  child: IconButton(
                                      icon: Icon(Icons.add),
                                      color: Colors.white,
                                      iconSize: 75,
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => SecondRoute()));
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colorblue,
          elevation: 0,
          title: Text('Perfil'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.star),
              onPressed: () {},
            ),
          ],
          centerTitle: true,
        ),

      ),
    );
  }
}

class FirstRoute extends StatelessWidget {
  final elementos = List<Elemento>.generate(
    20,
    (index) => Elemento('$index', 'aaaa'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
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
