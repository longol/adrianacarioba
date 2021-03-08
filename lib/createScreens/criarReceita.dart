import 'package:adrianacarioba/helpers/objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

class CriarReceitaScreen extends StatefulWidget {
  static String screenId = "criarReceita";

  @override
  _CriarReceitaScreenState createState() => _CriarReceitaScreenState();
}

class _CriarReceitaScreenState extends State<CriarReceitaScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _createForm(),
    );
  }

  Widget _createForm() {
    return FormBuilder(
      key: _fbKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        children: <Widget>[
          FormBuilderTextField(
            attribute: "test",
            validators: [
              FormBuilderValidators.required(),
            ],
            decoration: InputDecoration(
              labelText: "test",
            ),
          ),
          FormBuilderFilterChip(
            decoration: InputDecoration(
                labelText: 'contactQuery',
                labelStyle:
                    TextStyle(fontSize: 21, fontWeight: FontWeight.normal)),
            attribute: "category",
            options: [
              FormBuilderFieldOption(child: Text('mobile'), value: "mobile"),
              FormBuilderFieldOption(child: Text('web'), value: "web"),
              FormBuilderFieldOption(child: Text('vr'), value: "vr"),
              FormBuilderFieldOption(child: Text('contactAR'), value: "ar"),
              FormBuilderFieldOption(
                  child: Text('contactWearable'), value: "wearable"),
              FormBuilderFieldOption(
                  child: Text('research'), value: "research"),
            ],
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
    );
  }

  void _enviarAction() {
    if (_fbKey.currentState.saveAndValidate()) {
      print("DEBUG: _enviarAction: ${_fbKey.currentState.value}");
    }
  }

  void _resetAction() {
    _fbKey.currentState.reset();
    print("DEBUG: _resetAction: ${_fbKey.currentState.value}");
  }
}
