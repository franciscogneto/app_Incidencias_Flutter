import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Incidence.dart';
import 'package:incidencias_app/models/Item.dart';
import 'package:incidencias_app/models/Util.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:incidencias_app/services/services.dart';


/*class AddIncidence extends StatelessWidget {
  String type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incidência"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        child: AddIncidenceForm(),
      ),
    );
  }
}*/

class AddIncidenceForm extends StatefulWidget {
  var items = new List<Item>();

  int currentState;
  AddIncidenceForm(this.auth,this.user){
    items = [];
    items.add(Item(title: 'Instalação elétrica', checked: false));
    items.add(Item(title: 'Estacionamento', checked: false));
    items.add(Item(title: 'Sala de Aula', checked: false));
    items.add(Item(title: 'Objeto quebrado', checked: false));
    items.add(Item(title: 'Objeto solto', checked: false));
    currentState = 0;
  }
  final DocumentSnapshot user;
  final FirebaseAuth auth;


  @override
  _AddIncidenceFormState createState() => _AddIncidenceFormState();


}

class _AddIncidenceFormState extends State<AddIncidenceForm> {
  final _formKey = GlobalKey<FormState>();
  String _erroMessage = '', _textField = '', _response = '';
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  int totalStates = 4;
  Position localization;
  File _image;
  final picker = ImagePicker();
  Future getImage() async{
    final image2 = await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image2.path);
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incidência"),
        centerTitle: true,
        backgroundColor: Color(0xFF398AE5),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Theme(//CHANGE THE STEPPER CONTEXT COLLORS
        data: ThemeData(
          accentColor: Colors.indigo,
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Stepper(
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,

                  steps: <Step>[
                    Step(
                      title: Text('Tipo da incidência'),
                      content: Column(
                        children: [
                          ListView.builder(
                            itemCount: widget.items.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index){//como deve construir esses itens na tela
                              final item = widget.items[index];

                              return CheckboxListTile(
                                title: Text(item.title),
                                key: Key(item.title),
                                value: item.checked,
                                activeColor: Colors.indigo,
                                onChanged: (value){
                                  setState(() {
                                    item.checked = value;
                                  });

                                },
                              );
                            },
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1 ?
                      StepState.complete : StepState.editing,
                    ),
                    Step(
                      title: Text('Descrição'),
                      content:  Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Adicione uma descrição",
                              labelStyle: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                            style: TextStyle(fontSize: 15),
                            onChanged: (text){
                              setState(() {
                                _textField = text;
                              });
                            },
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 1,
                      state: _currentStep >= 2 ?
                      StepState.complete : StepState.editing,
                    ),
                    Step(
                      title: Text('Adicionar uma foto'),
                      content:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              icon: Icon(
                                  Icons.add_a_photo
                              ),
                              color: Colors.indigo,
                              iconSize: 40,
                              onPressed: getImage,
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 2,
                      state: _currentStep >= 3 ?
                      StepState.complete : StepState.editing,
                    ),
                    Step(
                      title: Text('Adicionar localização'),
                      content:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              icon: Icon(
                                  Icons.location_on
                              ),
                              color: Colors.indigo,
                              iconSize: 40,
                              onPressed: () async{
                                Future<Position> position = _determinePosition();
                              position.then((value) => localization = value);
                              }
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 3,
                      state: _currentStep >= 4 ?
                      StepState.complete : StepState.editing,
                    ),
                  ],
                ),
              ),
              Text(
                _response,
                style: TextStyle(
                  color: Colors.amber,
                  letterSpacing: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),

              ),//ListView
            ], //Lista principal
          ),
        ),
      ), //Coluna principal
      //SingleChild
    );
  }





  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position;
    await Geolocator.getCurrentPosition().then((value) => position = value);
    return position;
  }



  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() async {

    if(_currentStep + 1 == totalStates){
      List<Item> getTrueItems = new List<Item>();
      int count;
      await services().getCountIncidentesByEmail(widget.auth.currentUser.email).then((value) => count = value);
      String path = 'images/' + widget.user.id + '/Incidence_'+count.toString()+'.jpg'; //Falta colocar o numero da incidencia no final do nome
      widget.items.forEach((element) {
        if(element.checked){
          getTrueItems.add(element);
        }
      });
      Incidence data = Incidence(
        description: _textField,
        status: 2,
        type: 'Incidência',
        date: new DateTime.now(),
        items: getTrueItems,
        pathToImage: path,
        location: localization,
      );
      services().addIncidenceByEmail(data, widget.auth.currentUser.email, _image, path).then((value) => _response = value);




      /*await FirebaseFirestore.instance.collection('User').doc(widget.user.id).set(util.toJson()).then((value) => print('ok'));

        try{
        await FirebaseStorage.instance.ref(path).putFile(_image);
        } on FirebaseException catch (e){
          print(e.code);
        }*/
    }
    _currentStep < this.totalStates - 1 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

}


class teste extends StatelessWidget {

  const teste(this.image);
  final image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('aaaa'),
      ),
      body: Center(
        child: Image.file(image),
      ),
    );
  }
}
