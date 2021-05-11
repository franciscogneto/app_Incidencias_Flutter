
import 'package:flutter/material.dart';
import 'package:incidencias_app/pages/menu_page.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incidencias_app/pages/menu_page.dart';
import 'package:loading/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  String _email, _password;
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  //final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: FutureBuilder(
        future: _fApp,
        builder: (context,snapshot) {
          if(snapshot.hasError){
            return Text('Erro');
          }else if(snapshot.hasData) {
            return LoginPage();

          } else {
            return Center(
              child: Loading(indicator: BallPulseIndicator(), size: 100.0,color: Colors.indigo),
            );
          }
        }
      ),
      //LoginPage(),
    );
  }
}

/*class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginPage(),
    );
  }
}*/

