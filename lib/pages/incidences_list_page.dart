import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Incidence.dart';
import 'package:incidencias_app/pages/incidence_detail.dart';
import 'package:intl/intl.dart';


class IncidencesList extends StatefulWidget {
  var incidences = new List<Incidence>();

  IncidencesList() {
    incidences = [];
    incidences.add(Incidence(
        type: 'matutenção',
        description: 'na rua perto do prédio C',
        status: 2));
    incidences.add(Incidence(
        type: 'quebrado', description: 'Cano perto do prédio K', status: 2));
    incidences.add(Incidence(
        type: 'verificação',
        description: 'Computador 2 do laboratório A',
        status: 1));
    incidences.add(Incidence(
        type: 'Corrigir',
        description: 'gramado ruim',
        status: 3));
  }

  @override
  _IncidencesListState createState() => _IncidencesListState();
}

class _IncidencesListState extends State<IncidencesList> {
  @override
  Widget build(BuildContext context) {
    print(widget.incidences);
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas incidências'),
        backgroundColor: Color(0xFF398AE5),
      ),
      body: Column(
        children: <Widget>[
          ListView.builder(
            itemCount: widget.incidences.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              //como deve construir esses itens na tela
              final item = widget.incidences[index];
              return IncidenceWidget(item);
            },
          ),
        ],
      ),
    );
  }
}

class IncidenceWidget extends StatelessWidget {
  const IncidenceWidget(this.item);

  final Incidence item;
  @override
  Widget build(BuildContext context) {
    Color color;
    var f = new DateFormat('dd/MM/yyyy - kk:mm').format(item.date);
    if (item.status == 1) {
      color = Colors.green;
    } else if (item.status == 2) {
      color = Colors.yellow;
    } else {
      color = Colors.red;
    }
    return ListTile(
      title: Text(f),
      subtitle: Text(item.type),
      trailing: Icon(Icons.circle, color: color),
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => IncidenceDetail(item)));
      },
    );
  }
}
