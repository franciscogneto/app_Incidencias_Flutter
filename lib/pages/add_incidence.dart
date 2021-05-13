import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Item.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddIncidence extends StatelessWidget {
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
}

class AddIncidenceForm extends StatefulWidget {
  var items = new List<Item>();

  int currentState;

  AddIncidenceForm(){
    items = [];
    items.add(Item(title: 'Instalação elétrica', checked: false));
    items.add(Item(title: 'Estacionamento', checked: false));
    items.add(Item(title: 'Sala de Aula', checked: false));
    items.add(Item(title: 'Objeto quebrado', checked: false));
    items.add(Item(title: 'Objeto solto', checked: false));

    currentState = 0;


  }

  @override
  _AddIncidenceFormState createState() => _AddIncidenceFormState();
}

class _AddIncidenceFormState extends State<AddIncidenceForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  int totalStates = 4;

  File _image;
  final picker = ImagePicker();
  Future getImage() async{
    final image2 = await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image2.path);
    });
    print(_image);
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
                              print(index);
                              return CheckboxListTile(
                                title: Text(item.title),
                                key: Key(item.title),
                                value: item.checked,
                                activeColor: Colors.indigo,
                                onChanged: (value){
                                  setState(() {
                                    item.checked = value;
                                  });
                                  print(item.toString());
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
                                Future<Position> response = _determinePosition();
                              response.then((value) => print(value.toJson()));
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
              ), //ListView

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
        try{
        await FirebaseStorage.instance.ref('images/aa/teste.jpg').putFile(_image);
        } on FirebaseException catch (e){
          print(e.code);
        }
        /*firebaseStorage uploadTask = firebaseStorageRef.putFile(_image).then((e) => print(e.toString()));
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        taskSnapshot.ref.getDownloadURL().then(
              (value) => print("Done: $value"),
        );*/

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
