import 'dart:io';

import 'package:adrianacarioba/allTranslations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adrianacarioba/helpers/objects.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class CriarReceitaScreen extends StatefulWidget {
  static String screenId = 'criarReceita';

  @override
  _CriarReceitaScreenState createState() => _CriarReceitaScreenState();
}

class _CriarReceitaScreenState extends State<CriarReceitaScreen> {
  List utensilios = [];
  String utensiliosResult = '';
  String categoria = '';
  List<IngredienteReceita> ingredienteInputCards = [];
  List ingredientesFields = [];
  List utensiliosDataSource = [];
  bool didChange = false;

  File _pickedImage;
  final picker = ImagePicker();

  @override
  void initState() {
    selectorDataFor('utensilios');
    ingredientesFields = ['Novo ingrediente'];
    IngredienteReceita ir =
        IngredienteReceita(1, Medida.xicaras, "abobrinha", "Bem madura");
    ingredienteInputCards = [ir];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _createForm(context);
  }

  Widget _createForm(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          children: _buildFormFields(),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    List<Widget> fields = [];

    fields.add(_sectionTitle(title: allTranslations.text('newRecipe')));
    fields.add(_imagePicker());
    fields.add(_textField(name: 'Nome da receita', required: true));
    fields.add(_textField(name: 'Descrição', required: false));

    fields.add(_sectionTitle(title: 'Tempos de execução'));
    fields.add(_textField(name: 'Tempo de preparo', required: true));
    fields.add(_textField(name: 'Tempo de cozimento', required: false));
    fields.add(_textField(name: 'Tempo de resfriamento', required: false));
    fields.add(_textField(name: 'Validade', required: false));
    fields.add(_multiFormField('Utensilios', utensiliosDataSource));

    fields.add(_sectionTitle(title: 'Ingredientes'));
    List<Widget> ingredienteContainer = _ingredientesContainer();
    fields.addAll(ingredienteContainer);

    fields.add(_sectionTitle(title: 'Ingrediente Input Cards'));
    List<Widget> ingredienteInputCards = _ingredienteInputCards();
    fields.addAll(ingredienteInputCards);

    fields.add(_actionButtons());
    return fields;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _pickedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> selectorDataFor(String documentName) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('selectorData')
        .doc(documentName)
        .get();
    ds.data().forEach((key, value) {
      utensiliosDataSource.add({'display': value, 'value': key});
    });
  }

  Widget _sectionTitle({String title}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Divider(
            height: 20,
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        ElevatedButton(
          onPressed: _enviarAction,
          child: Text('Enviar'),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: _resetAction,
          child: Text('Resetar'),
        ),
        Spacer(),
      ],
    );
  }

  // ignore: unused_element
  Widget _dropDownField(String dropdownValue) {
    return DropdownButton<String>(
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
    );
  }

  Widget _multiFormField(String fieldName, List dataSource) {
    return MultiSelectFormField(
      autovalidate: false,
      chipBackGroundColor: Colors.red,
      chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
      checkBoxActiveColor: Colors.green.shade400,
      checkBoxCheckColor: Colors.white,
      dialogShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Text(
        fieldName,
        style: TextStyle(fontSize: 16),
      ),
      validator: (value) {
        if (value == null || value.length == 0) {
          return 'Favor selecionar ao menos uma opção';
        }
        return null;
      },
      dataSource: dataSource,
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCELAR',
      hintWidget: Text('Selecione um ou mais'),
      initialValue: utensilios,
      onSaved: (value) {
        if (value == null) return;
        setState(() {
          utensilios = value;
        });
      },
    );
  }

  Widget _textField({String name, bool required}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
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
      ),
    );
  }

  Widget _imagePicker() {
    return Center(
      child: Container(
        width: 200.0,
        height: 200.0,
        child: MaterialButton(
          onPressed: getImage,
          child: _pickedImage == null
              ? Icon(Icons.add_a_photo)
              : Image.file(_pickedImage),
        ),
      ),
    );
  }

  List<Widget> _ingredienteInputCards() {
    List<Widget> result = [];

    ingredienteInputCards.asMap().forEach((index, inputCard) {
      List<Widget> rowElements = [
        Text(
          inputCard.description(),
        ),
      ];

      rowElements.addAll(_rowEditButtonsIngredients(
          index: index, count: ingredienteInputCards.length));

      Widget ingredienteContainer = Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: rowElements,
        ),
      );

      result.add(ingredienteContainer);
    });

    return result;
  }

  List<Widget> _ingredientesContainer() {
    List<Widget> result = [];

    ingredientesFields.asMap().forEach((index, element) {
      List<Widget> rowElements = [
        Expanded(
          child: _textField(name: element, required: false),
        )
      ];

      rowElements.addAll(_rowEditButtonsIngredients(
          index: index, count: ingredientesFields.length));

      Widget ingredienteContainer = Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: rowElements,
        ),
      );

      result.add(ingredienteContainer);
    });

    return result;
  }

  List<Widget> _rowEditButtonsIngredients({int index, int count}) {
    List<Widget> buttons = [];

    Widget addButton = Padding(
      padding: const EdgeInsets.all(1.0),
      child: SizedBox(
        width: 40,
        height: 30,
        child: ElevatedButton(
          onPressed: () {
            IngredienteReceita ir = IngredienteReceita(
                1, Medida.xicaras, "abobrinha", "Bem madura");
            setState(() {
              ingredienteInputCards.add(ir);
              ingredientesFields.insert(index, 'Novo ingrediente');
            });
          },
          child: Text('+'),
        ),
      ),
    );

    Widget deleteButton = Padding(
      padding: const EdgeInsets.all(1.0),
      child: SizedBox(
        width: 40,
        height: 30,
        child: ElevatedButton(
          onPressed: () {
            if (ingredienteInputCards.length > 1) {
              ingredienteInputCards.removeAt(index);
              setState(() {
                didChange = !didChange;
              });
            }
            if (ingredientesFields.length > 1) {
              ingredientesFields.removeAt(index);
              setState(() {
                didChange = !didChange;
              });
            }
          },
          child: Text('-'),
        ),
      ),
    );

    if (count == 1) {
      buttons.add(addButton);
    } else if (index == count - 1) {
      buttons.add(deleteButton);
      buttons.add(addButton);
    }

    return buttons;
  }

  void _enviarAction() {
    if (_formKey.currentState.validate()) {
      utensiliosResult = utensilios.toString();
    }
  }

  void _resetAction() {
    utensilios = [];
    utensiliosResult = '';
    _pickedImage = null;
    ingredientesFields = ['Novo ingrediente'];
    IngredienteReceita ir =
        IngredienteReceita(1, Medida.xicaras, "abobrinha", "Bem madura");
    ingredienteInputCards = [ir];
    _formKey.currentState.reset();

    setState(() {
      didChange = !didChange;
    });
  }
}
