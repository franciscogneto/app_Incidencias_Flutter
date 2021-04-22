import 'package:flutter/material.dart';

import 'incidences_list_page.dart';
import 'add_incidence.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incidencias_app/pages/login_page.dart';


class MenuPage extends StatefulWidget{

  const MenuPage(this.auth);
  final FirebaseAuth auth;
  @override
  _MenuPage createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  final Colorblue = Colors.indigo;
  final String image = 'https://conteudo.imguol.com.br/c/entretenimento/13/2017/09/20/marcos-o-vin-diesel-brasileiro-1505924753054_v2_900x506.jpg.webp';
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
                          widget.auth.currentUser.email,
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
                          top: 10,

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
                                        MaterialPageRoute(builder: (context) => IncidencesList()));
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
                                            MaterialPageRoute(builder: (context) => AddIncidenceForm()));
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
              icon: Icon(Icons.logout),
              onPressed: () {
                widget.auth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
          centerTitle: true,
        ),
      ),
    );
  }
}

