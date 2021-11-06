import 'package:projeto_banco/models/chamados.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ChamadoPage extends StatefulWidget {
  final Chamado chamado;
  ChamadoPage({this.chamado});

  @override
  _ChamadoPageState createState() => _ChamadoPageState();
}

class _ChamadoPageState extends State<ChamadoPage> {
  final _tituloController = TextEditingController();
  final _responsavelController = TextEditingController();
  final _interacaoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _statusController = TextEditingController();
  final _relatorController = TextEditingController();
  final _imgController = TextEditingController();
  final _tituloFocus = FocusNode();
  bool _userEdited = false;
  Chamado _editedChamado;

  @override
  void initState() {
    super.initState();

    if (widget.chamado == null) {
      _editedChamado = Chamado();
    } else {
      _editedChamado = Chamado.fromMap(widget.chamado.toMap());

      _tituloController.text = _editedChamado.titulo;
      _responsavelController.text = _editedChamado.responsavel;
      _interacaoController.text = _editedChamado.interacao;
      _categoriaController.text = _editedChamado.categoria;
      _statusController.text = _editedChamado.status;
      _relatorController.text = _editedChamado.relator;
      _imgController.text = _editedChamado.img;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedChamado.titulo ?? "Novo Chamado"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedChamado.titulo != null &&
                  _editedChamado.titulo.isNotEmpty) {
                Navigator.pop(context, _editedChamado);
              } else {
                FocusScope.of(context).requestFocus(_tituloFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.grey,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: _tituloController,
                  focusNode: _tituloFocus,
                  decoration: InputDecoration(labelText: "Título"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedChamado.titulo = text;
                    });
                  },
                ),
                TextField(
                  controller: _responsavelController,
                  decoration: InputDecoration(labelText: "Responsável"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.responsavel = text;
                  },
                ),
                TextField(
                  controller: _interacaoController,
                  decoration: InputDecoration(labelText: "Conteudo"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.interacao = text;
                  },
                ),
                TextField(
                  controller: _categoriaController,
                  decoration: InputDecoration(labelText: "Categoria"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.categoria = text;
                  },
                ),
                TextField(
                  controller: _statusController,
                  decoration: InputDecoration(labelText: "Status"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.status = "Novo";
                  },
                ),
                TextField(
                  controller: _relatorController,
                  decoration: InputDecoration(labelText: "Relator"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.relator = text;
                  },
                ),
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _editedChamado.img != null
                              ? FileImage(File(_editedChamado.img))
                              : AssetImage("images/person.png"),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: [
                FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child: Text("Sim"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}