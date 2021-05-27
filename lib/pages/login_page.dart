import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'menu_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  String _email = '', _password = '', _erroMessage = '';
  final auth = FirebaseAuth.instance;

  _buildEmailContext() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFF6CA8F1),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(15, 15),
              ),
            ],
          ),
          height: 60,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your email',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              ),
            ),
            onChanged: (value) {
              setState(() {
                _email = value.trim();
              });
            },
          ),
        ),
      ],
    );
  }

  _buildPasswordContext() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFF6CA8F1),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(15, 15),
              ),
            ],
          ),
          height: 60,
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your password',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontFamily: 'OpenSans',
              ),
            ),
            onChanged: (value) {
              setState(() {
                _password = value.trim();
              });
            },
          ),
        ),
      ],
    );
  }

  _buildSignInButton(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width / 2,
      child: RaisedButton(
        elevation: 10.0,
        onPressed: () async {
          try {
            await auth.signInWithEmailAndPassword(
                email: _email, password: _password);
            if (auth.currentUser != null) {
              DocumentSnapshot user;
              await FirebaseFirestore.instance
                  .collection('User')
                  .doc(_email)
                  .get()
                  .then((value) => user = value);
              if(user != null){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MenuPage(auth, user)));
              }
            }
          } on FirebaseAuthException catch (e) {
            setState(() {
              if (_password.trim().length == 0) {
                _erroMessage = 'incorrect password';
              } else if (e.code == 'unknown') {
                _erroMessage = 'password or email incorrect';
              } else {
                _erroMessage = e.code;
              }
            });
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        child: Text(
          'Sing In',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  _buildSignOutButton(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: MediaQuery.of(context).size.width / 2,
      child: RaisedButton(
        elevation: 10.0,
        onPressed: () async {
          try {
            UserCredential user = await auth.createUserWithEmailAndPassword(
                email: _email, password: _password).then((value) { print(value.user.toString());});
            if (user != null) {
              await FirebaseFirestore.instance
                  .collection('User')
                  .doc(_email)
                  .set({'creationData': new DateTime.now(), 'incidences': []})
                  .then((value) => print('Usuário Criado'))
                  .catchError((error) => print('error $error'));
              DocumentSnapshot user;
              await FirebaseFirestore.instance
                  .collection('User')
                  .doc(_email)
                  .get()
                  .then((value) => user = value);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuPage(auth, user)));
            } else {
              print('Erro inesperado');
            }
          } on FirebaseAuthException catch (e) {
            setState(() {
              if (_password.trim().length == 0) {
                _erroMessage = 'incorrect password';
              } else if (e.code == 'unknown') {
                _erroMessage = 'password or email incorrect';
              } else {
                _erroMessage = e.code;
              }
            });
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        child: Text(
          'Sing Up',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
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
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 120,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  _buildEmailContext(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildPasswordContext(),
                  SizedBox(
                    height: 30,
                  ),
                  _buildSignInButton(context),
                  _buildSignOutButton(context),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    _erroMessage.toString(),
                    style: TextStyle(
                      color: Colors.amber,
                      letterSpacing: 1.5,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*class _LoginPage extends State<LoginPage> {
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
*/
