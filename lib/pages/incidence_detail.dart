import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incidencias_app/models/Incidence.dart';
import 'package:incidencias_app/services/services.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class IncidenceDetail extends StatelessWidget {
  const IncidenceDetail(this.item);
  final Incidence item;
  @override
  Widget build(BuildContext context) {
    String text;
    Icon icon;
    if (item.status == 1) {
      text = 'Aprovado, muito obrigado pela ajuda!';
      icon = Icon(
        Icons.emoji_events,
        color: Colors.yellow,
      );
    } else if (item.status == 2) {
      text = 'Em andamento';
      icon = Icon(
        Icons.timelapse,
        color: Color(0xFF398AE5),
      );
    } else {
      text = 'Incidência incorreta';
      icon = Icon(
        Icons.sentiment_dissatisfied_sharp,
        color: Color(0xFF398AE5),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        backgroundColor: Color(0xFF398AE5),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Item(item.date.toString(), 'DATA'),
          Item(item.type, 'TIPO'),
          Item(item.description, 'DESCRIÇÃO'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('IMAGEM'),
                  IconButton(
                      icon: Icon(Icons.image, color: Color(0xFF398AE5)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShowImageFromFireBase(item.pathToImage)));
                      }),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('STATUS'),
                  Text(text),
                  icon,
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Item extends StatelessWidget {
  Item(String content, String title) {
    this.title = title;
    this.content = content;
  }

  String title;
  String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(title),
            Text(content ?? ''),
          ],
        ),
      ],
    );
  }
}

class ShowImageFromFireBase extends StatelessWidget {
  ShowImageFromFireBase(String path) {
    this.path = path;
  }
  String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incidência"),
        centerTitle: true,
        backgroundColor: Color(0xFF398AE5),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: services().getImageByPath(path),
              builder: (context, data) {
                if (data.connectionState == ConnectionState.waiting) {
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
                      ),
                    ],
                  );
                } else if (data.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.25,
                            height: MediaQuery.of(context).size.height / 1.25,
                            child: Image.memory(data.data),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (data.data == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Esta incidência não possui imagem'),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Erro, tente novamente mais tarde'),
                        ],
                      ),
                    ],
                  );
                }
              }),
        ],
      ),
    );
  }
}
