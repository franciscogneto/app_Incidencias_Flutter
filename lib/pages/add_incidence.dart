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

  AddIncidenceForm(){
    items = [];
    items.add(Item(title: 'Instalação elétrica', checked: false));
    items.add(Item(title: 'Estacionamento', checked: false));
    items.add(Item(title: 'Sala de Aula', checked: false));
    items.add(Item(title: 'Objeto quebrado', checked: false));
    items.add(Item(title: 'Objeto solto', checked: false));
  }

  @override
  _AddIncidenceFormState createState() => _AddIncidenceFormState();
}

class _AddIncidenceFormState extends State<AddIncidenceForm>{

  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Incidência"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(

          mainAxisAlignment:  MainAxisAlignment.start,
          children: <Widget>[

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
            ),


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
            ),
          ],
        ),
      ),
    );
  }
}

