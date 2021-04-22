import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Item.dart';

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
  AddIncidenceForm() {
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Incidência"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
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
                              onPressed: (){}
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
                              onPressed: (){}
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 3,
                      state: _currentStep >= 4 ?
                      StepState.complete : StepState.editing,
                    ),
                  ],
                ),
              ), /*
                Container(
                  padding: EdgeInsets.only(top: 10),
                    child: Text(
                        'tipo da incidência',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                ),
                Column(
                  children: <Widget>[
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
                          },
                        );
                      },
                    ),
                    SizedBox(height: 50,),
                    ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Adicione uma descrição",
                            labelStyle: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),// 1 Coluna


                ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.add_location),
                              onPressed: (){},
                              iconSize: 40,
                              color: Colors.indigo
                          ),
                          IconButton(
                              icon: Icon(
                                  Icons.add_a_photo
                              ),
                              color: Colors.indigo,
                              iconSize: 40,
                              onPressed: (){}
                          ),
                          IconButton(
                              icon: Icon(Icons.send),
                              iconSize: 40,
                              color: Colors.indigo,
                              onPressed: (){
                              }),
                        ],
                      ),
                    ),
                  ],
                ),*/ //ListView
            ], //Lista principal
          ),
        ),
      ), //Coluna principal
      //SingleChild
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < this.totalStates - 1 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
