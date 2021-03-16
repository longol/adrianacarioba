import 'package:adrianacarioba/allTranslations.dart';
import 'package:flutter/material.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class CriarReceitaScreen extends StatefulWidget {
  static String screenId = "criarReceita";

  @override
  _CriarReceitaScreenState createState() => _CriarReceitaScreenState();
}

class _CriarReceitaScreenState extends State<CriarReceitaScreen> {
  @override
  Widget build(BuildContext context) {
    return _createForm(context);
  }

  Widget _createForm(context) {
    String dropdownValue = 'One';

    final String language = allTranslations.currentLanguage;
    print("current language: ${language}");
    String newRecipe = allTranslations.text('newRecipe');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          children: <Widget>[
            _sectionTitle(title: newRecipe),
            _textField(name: 'Nome da receita', required: true),
            _textField(name: 'Descrição', required: false),
            _textField(name: 'Foto', required: false),
            _sectionTitle(title: "Tempos de execução  "),
            _textField(name: 'Tempo de preparo', required: true),
            _textField(name: 'Tempo de cozimento', required: false),
            _textField(name: 'Tempo de resfriamento', required: false),
            _textField(name: 'Validade', required: false),
            _sectionTitle(title: "Utensílios"),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>['One', 'Two', 'Free', 'Four']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                ElevatedButton(
                  onPressed: _enviarAction,
                  child: Text("Enviar"),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _resetAction,
                  child: Text("Resetar"),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _sectionTitle({String title}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  _textField({String name, bool required}) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: name,
      ),
      validator: (String value) {
        if (required) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
        }
        return null;
      },
    );
  }

  // ignore: unused_element
  void _enviarAction() {
    // if (_fbKey.currentState.saveAndValidate()) {
    //   print("DEBUG: _enviarAction: ${_fbKey.currentState.value}");
    // }
  }

  // ignore: unused_element
  void _resetAction() {
    // _fbKey.currentState.reset();
    // print("DEBUG: _resetAction: ${_fbKey.currentState.value}");
  }
}
