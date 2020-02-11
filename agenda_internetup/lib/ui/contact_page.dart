import 'dart:async';
import 'dart:io';

import 'package:agenda_internetup/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _momController = TextEditingController();
  final _cpfController = TextEditingController();
  final _rgController = TextEditingController();
  final _datebornController = TextEditingController();
  final _andressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  final _validController = TextEditingController();
  final _planController = TextEditingController();
  final _costController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contact _editedContact;



  @override
  void initState() {
    super.initState();

    if(widget.contact == null){
      _editedContact = Contact();

    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _momController.text = _editedContact.mom;
      _cpfController.text = _editedContact.cpf;
      _rgController.text = _editedContact.rg;
      _datebornController.text = _editedContact.dateborn;
      _andressController.text = _editedContact.andress;
      _phoneController.text = _editedContact.phone;
      _noteController.text = _editedContact.note;
      _validController.text = _editedContact.valid;
      _planController.text = _editedContact.plan;
      _costController.text = _editedContact.cost;
      _emailController.text = _editedContact.email;


    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(_editedContact.name ?? "Novo Cliente"),
          centerTitle: true,

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedContact.name != null &&  _editedContact.name.isNotEmpty){    //VERIFICAÇAO DE PREENCHIMENTO
              Navigator.pop(context, _editedContact);

            } else {
              FocusScope.of(context).requestFocus(_nameFocus);

            }

          },
          child: Icon(Icons.save),
          backgroundColor: Colors.blueAccent,

        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null ?
                        FileImage(File(_editedContact.img)) :
                        AssetImage("images/person.jpeg")
                    ),
                  ),
                ),
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                    if(file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _momController,
                decoration: InputDecoration(labelText: "Nome da Mãe"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.mom = text;
                },
              ),

              TextField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: "CPF"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.cpf = text;
                },
                keyboardType: TextInputType.number, maxLength: 14,

              ),
              TextField(
                controller: _rgController,
                decoration: InputDecoration(labelText: "RG"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.rg = text;
                },
                keyboardType: TextInputType.number, maxLength: 7,

              ),
              TextField(
                controller: _datebornController,
                decoration: InputDecoration(labelText: "Data de nascimento"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.dateborn = text;
                },
                keyboardType: TextInputType.datetime, maxLength: 10,

              ),
              TextField(
                controller: _andressController,
                decoration: InputDecoration(labelText: "Endereço"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.andress = text;
                },
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone, maxLength: 11,
              ),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(labelText: "Telefone para recado"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.note = text;
                },
                keyboardType: TextInputType.phone, maxLength: 11,
              ),
              TextField(
                controller: _validController,
                decoration: InputDecoration(labelText: "Vencimento"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.valid = text;
                },
                keyboardType: TextInputType.datetime, maxLength: 10,

              ),
              TextField(
                controller: _planController,
                decoration: InputDecoration(labelText: "Plano"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.plan = text;

                },
                keyboardType: TextInputType.multiline,
              ),
              TextField(
                controller: _costController,
                decoration: InputDecoration(labelText: "Taxa"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.cost = text;
                },
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.email = text;

                },
                keyboardType: TextInputType.emailAddress,

              ),
            ],
          ),

        ),
      ),
    );
  }
  Future<bool> _requestPop(){                  // PERGUNTA NA SETINHA DE VOLTAR
    if(_userEdited){
      showDialog(context: context,
        builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content:  Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);

                  },
                ),
              ],
            );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);

    }

  }

}
