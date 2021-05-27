import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Incidence.dart';
import 'package:incidencias_app/models/Item.dart';
import 'package:geolocator/geolocator.dart';
import 'package:incidencias_app/pages/menu_page.dart';
import 'package:incidencias_app/services/services.dart';

class AddIncidenceForm extends StatefulWidget {
  var items = new List<Item>();

  int currentState;
  AddIncidenceForm(this.auth, this.user) {
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
  _AddIncidenceFormState() {
    _textField = '';
    _response = '';
    localization = null;
  }

  String _textField = '', _response = '';
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  int totalStates = 4;
  Position localization;
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final image2 =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image2.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_currentStep + 1 != totalStates){
      setState(() {
        _response = '';
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Incidência"),
        centerTitle: true,
        backgroundColor: Color(0xFF398AE5),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuPage(widget.auth, widget.user)));
            //Navigator.pop(context);
          },
        ),
      ),
      body: Theme(
        //CHANGE THE STEPPER CONTEXT COLLORS
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
                            itemBuilder: (BuildContext context, int index) {
                              //como deve construir esses itens na tela
                              final item = widget.items[index];
                              return CheckboxListTile(
                                title: Text(item.title),
                                key: Key(item.title),
                                value: item.checked,
                                activeColor: Colors.indigo,
                                onChanged: (value) {
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
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.editing,
                    ),
                    Step(
                      title: Text('Descrição'),
                      content: Column(
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
                            onChanged: (text) {
                              setState(() {
                                _textField = text;
                              });
                            },
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 1,
                      state: _currentStep >= 2
                          ? StepState.complete
                          : StepState.editing,
                    ),
                    Step(
                      title: Text('Adicionar uma foto'),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add_a_photo),
                            color: Color(0xFF398AE5),
                            iconSize: 40,
                            onPressed: getImage,
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 2,
                      state: _currentStep >= 3
                          ? StepState.complete
                          : StepState.editing,
                    ),
                    Step(
                      title: Text('Adicionar localização'),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              icon: Icon(Icons.location_on),
                              color: Color(0xFF398AE5),
                              iconSize: 40,
                              onPressed: () async {
                                Future<Position> position =
                                    _determinePosition();
                                String aux;
                                position.then((value) { localization = value; if(value != null){setState(() {
                                  _response = 'Localização adicionada';
                                }); } });
                              }),
                        ],
                      ),
                      isActive: _currentStep >= 3,
                      state: _currentStep >= 4
                          ? StepState.complete
                          : StepState.editing,
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  _response ?? '',
                  style: TextStyle(
                    color: Colors.amber,
                    letterSpacing: 1.5,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
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
      return Future.error('Serviços de locazalição desabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão de localização recusada');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Permissões de localização estão permanentemente desabilitados');
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
    String response = '';
    if (_currentStep + 1 == totalStates) {
      List<Item> getTrueItems = new List<Item>();
      int count;
      String path;
      if (_image != null) {
        await services()
            .getCountIncidentesByEmail(widget.auth.currentUser.email)
            .then((value) => count = value);
        path = 'images/' +
            widget.user.id +
            '/Incidence_' +
            count.toString() +
            '.jpg';
      }

      widget.items.forEach((element) {
        if (element.checked) {
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

      if (localization != null &&
          _textField != '' &&
          getTrueItems.length != 0) {
        await services()
            .addIncidenceByEmail(
                data, widget.auth.currentUser.email, _image, path)
            .then((value) {
          if ((value == 'Incidência adicionada')) {
            setState(() {
              _response = value;
              localization = null;
              widget.items.forEach((element) {
                element.reset();
              });
            });


          } else {
            setState(() {
              _response = value;
            });
          }
        });
      } else {
        setState(() {
          _response = 'Tipo, localização e descrição são obrigatórios!';
        });
      }
    }

    _currentStep < this.totalStates - 1
        ? setState(() => _currentStep += 1)
        : null;
  }

  cancel() {
    setState(() {
      _response = '';
    });
    _currentStep > 0
        ? setState(() {
            _currentStep -= 1;
            _response = '';
          })
        : null;
  }
}
