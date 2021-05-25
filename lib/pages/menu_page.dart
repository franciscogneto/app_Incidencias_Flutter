import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'incidences_list_page.dart';
import 'add_incidence.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incidencias_app/pages/login_page.dart';
import 'package:incidencias_app/models/Util.dart';
import 'package:incidencias_app/services/services.dart';

class MenuPage extends StatefulWidget {
  const MenuPage(this.auth, this.user);
  final DocumentSnapshot user;

  final FirebaseAuth auth;

  @override
  _MenuPage createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  final Colorblue = Colors.indigo;


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
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF73AEF5),
                    Color(0xFF61A4F1),
                    Color(0xFF478DE0),
                    Color(0xFF398AE5),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.user.id,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //incidencias / imagem / em aberto
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          auxText(25, 'OpenSans', 'Total de incidências'),
                          FutureBuilder(
                              future: services().getUtilDataFromUserByEmail(widget.auth.currentUser.email),
                              builder: (context,data){
                                if(data.hasData){
                                  return auxText(25, 'OpenSans', data.data.incidences.length.toString());
                                } else if (data.connectionState == ConnectionState.waiting){
                                  return auxText(20, 'OpenSans', 'Carregando...');
                                }
                                else {

                                  return auxText(20, 'OpenSans', 'Erro, tente novamente mais tarde');
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Column(
                      children: <Widget>[
                        auxText(25, 'OpenSans', 'Incidência em aberto'),
                        FutureBuilder(
                            future: services().getUtilDataFromUserByEmail(widget.auth.currentUser.email),
                            builder: (context,data){
                              if(data.hasData){
                                int qtd = 0;
                                data.data.incidences.forEach((element){
                                  if(element.status == 2)
                                    qtd++;
                                });
                                return auxText(25, 'OpenSans', qtd.toString());
                              } else if (data.connectionState == ConnectionState.waiting){
                                return auxText(20, 'OpenSans', 'Carregando...');
                              }
                              else {
                                return auxText(20, 'OpenSans', 'Erro, tente novamente mais tarde');
                              }
                            }),
                      ],
                    ),
                  ]),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.yellow,
                        size: 75,
                      ),
                      FutureBuilder(
                          future: services().getUtilDataFromUserByEmail(widget.auth.currentUser.email),
                          builder: (context,data){
                            if(data.hasData){
                              int qtd = 0;
                              data.data.incidences.forEach((element){
                                if(element.status == 1)
                                  qtd++;
                              });

                              int rest = qtd%5;
                              int result = (qtd/5).toInt();
                              return auxText(20, 'OpenSans', '$rest/5  ($result)' );
                            } else if (data.connectionState == ConnectionState.waiting){
                              return auxText(20, 'OpenSans', 'Carregando...');
                            }
                            else {
                              return auxText(20, 'OpenSans', 'Erro, tente novamente mais tarde');
                            }
                          }),
                    ],
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
                      padding: EdgeInsets.only(top: 25, left: 25),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Color(0xFF398AE5),
                            ),
                            child: IconButton(
                                icon: Icon(Icons.list),
                                color: Colors.white,
                                iconSize: 75,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IncidencesList(widget.auth.currentUser.email)));
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
                                    color: Color(0xFF398AE5),
                                  ),
                                  child: IconButton(
                                      icon: Icon(Icons.add),
                                      color: Colors.white,
                                      iconSize: 75,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddIncidenceForm(
                                                        widget.auth,
                                                        widget.user)));
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
          backgroundColor: Color(0xFF73AEF5),
          elevation: 0,
          title: Text('Perfil'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await widget.auth.signOut();
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

class auxText extends StatelessWidget {
  auxText(double size, String family, String content){
    this.fontFamily = family;
    this.fontSize = size;
    this.content = content;
  }
  double fontSize;
  String fontFamily;
  String content;

  @override
  Widget build(BuildContext context) {
  return Text(
    content,
    style: TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontFamily: fontFamily,
    ),
  );
  }

}
