import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Incidence.dart';
import 'package:incidencias_app/pages/incidence_detail.dart';
import 'package:incidencias_app/services/services.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class IncidencesList extends StatefulWidget {
  final String email;
  const IncidencesList(this.email);

  @override
  _IncidencesListState createState() => _IncidencesListState();
}

class _IncidencesListState extends State<IncidencesList> {
  @override
  Widget build(BuildContext context) {
    //print(widget.incidences);
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas incidências'),
        centerTitle: true,
        backgroundColor: Color(0xFF398AE5),
      ),
      body: FutureBuilder(
          future: services().getUtilDataFromUserByEmail(widget.email),
          builder: (context, data) {
            if (data.hasData) {
              return ListView.builder(
                itemCount: data.data.incidences.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final item = data.data.incidences[index];
                  return IncidenceWidget(item);
                },
              );
            } else if (data.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loading(
                        indicator: BallPulseIndicator(),
                        size: 100,
                        color: Color(0xFF398AE5),
                      ),
                    ],
                  )
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Erro, tente novamente mais tarde',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
          }),
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
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => IncidenceDetail(item)));
      },
    );
  }
}
