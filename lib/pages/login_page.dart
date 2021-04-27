import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'menu_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget{

  @override
  _LoginPage createState() => _LoginPage();

}

class _LoginPage extends State<LoginPage> {
  String _email,_password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 100, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 128,
              height: 128,
              //child: Image.asset("assets/2.gif"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
              onChanged: (value){
                setState(() {
                  this._email = value.trim();
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
              onChanged: (value){
                setState(() {
                  _password = value.trim();
                });
              },
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              //Botão com bordas arredondadas e fundo degrade
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1], //dois intervalos
                  colors: [
                    //duas cores
                    Colors.lightBlueAccent,
                    Colors.indigo,
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: SizedBox.expand(
                //Toma todo o conteúdo do container
                child: RaisedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, //para alinhamento - space between para fazer espaço entre
                    children: <Widget>[
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        child: SizedBox(
                          child: Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MenuPage())),*/
                    //auth.signInWithEmailAndPassword(email: _email, password: _password);

                    //final String aux = _email;

                    try{
                        //Get
                        /* FirebaseFirestore.instance.collection('User')
                        .get()
                            .then((QuerySnapshot querySnapshot) {

                          querySnapshot.docs.forEach((element) {});
                        });*/
                        //Set
                        /*await FirebaseFirestore.instance.collection('User').doc('teste3').set({'ccc':'teste'}).then((value)=> print('ok ')).catchError((error)=> print('error'));*/
                        
                      await auth.signInWithEmailAndPassword(email: _email, password: _password);
                      if(auth.currentUser != null){
                        bool aux = false;
                        QueryDocumentSnapshot user;
                        await FirebaseFirestore.instance.collection('User')
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((element) {
                            if(element.id == _email){
                              user = element;
                              aux = true;
                              print('não é primeira vez');
                            }
                          });
                        });
                        print(aux);
                        if(!aux){
                          await FirebaseFirestore.instance.collection('User').doc(_email).set({'CriationData': new DateFormat('yyyy-MM-dd').format(new DateTime.now())}).then((value)=> print('Usuário Criado')).catchError((error)=> print('error $error'));
                          await FirebaseFirestore.instance.collection('User')
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                                print('primeira vez');
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => MenuPage(auth,querySnapshot.docs.last)));
                          });
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MenuPage(auth,user)));
                        }
                        print('logou');
                      }
                    } on FirebaseAuthException catch (e) {
                      print('usuário inválido ou ocorreu erro: $e');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ), // primeiro container
    );
  }
}
