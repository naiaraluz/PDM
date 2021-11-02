import 'dart:io';
import 'dart:async';
import 'package:projeto_banco/class_chamados/chamados.dart';
import 'package:projeto_banco/ui/contato_page.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChamadoConect conect = ChamadoConect();

  List<Chamado> chamados = List();

  @override
  void initState() {
    super.initState();

    /*Chamado c = Chamado();
    c.name = "Jorge Herpich";
    c.email = "pedro@gmail.com";
    c.phone = "0987654321";
    c.img = "";
    helper.saveChamado(c);*/

    _getAllChamados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chamados"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressionou");
          _showChamadoPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: chamados.length,
          itemBuilder: (context, index) {
            return _chamadoCard(context, index);
          }),
    );
  }

  Widget _chamadoCard(BuildContext context, int index) {
    return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: chamados[index].img != null
                              ? FileImage(File(chamados[index].img))
                              : AssetImage("images/person.png"),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chamados[index].titulo ?? "",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                      Text(chamados[index].responsavel ?? "",
                          style: TextStyle(fontSize: 18.0)),
                      Text(chamados[index].relator ?? "",
                          style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          print("oooon tapp");
          _showChamadoPage(chamado: chamados[index]);
        });
  }

  void _showChamadoPage({Chamado chamado}) async {
    final recChamado = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChamadoPage(
                  chamado: chamado,
                )));
    if (recChamado != null) {
      if (chamado != null) {
        await conect.updatechamado(recChamado);
      } else {
        await conect.saveChamado(recChamado);
      }
      _getAllChamados();
    }
  }

  void _getAllChamados() {
    conect.getAllChamados().then((list) {
      setState(() {
        chamados = list;
      });
      //print(list);
    });
  }
}