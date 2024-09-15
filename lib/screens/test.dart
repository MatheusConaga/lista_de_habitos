import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:monitoramento_de_habitos/models/habito_model.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final TextEditingController _nomeInputController = TextEditingController();
  final TextEditingController _descricaoInputController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Frequencia _frequenciaSelecionada = Frequencia.diario;

  List<Habito> habitos = [];

  @override
  void initState() {
    super.initState();
    _loadHabitos().then((loadedHabitos) {
      setState(() {
        habitos = loadedHabitos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hábitos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeInputController,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descricaoInputController,
                    decoration: InputDecoration(labelText: 'Descrição'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<Frequencia>(
                    value: _frequenciaSelecionada,
                    items: Frequencia.values.map((frequencia) {
                      return DropdownMenuItem<Frequencia>(
                        value: frequencia,
                        child: Text(frequencia.name),
                      );
                    }).toList(),
                    onChanged: (Frequencia? novaFrequencia) {
                      setState(() {
                        _frequenciaSelecionada = novaFrequencia!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Frequência'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _doAdd();
                      }
                    },
                    child: Text('Adicionar Hábito'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: habitos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(habitos[index].nome),
                    subtitle: Text(
                      'Descrição: ${habitos[index].descricao}\nFrequência: ${habitos[index].frequencia.name}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _doAdd() {
    Habito newHabito = Habito(
      nome: _nomeInputController.text,
      descricao: _descricaoInputController.text,
      frequencia: _frequenciaSelecionada,
    );

    setState(() {
      habitos.add(newHabito);
    });

    _saveHabito(newHabito);

    _nomeInputController.clear();
    _descricaoInputController.clear();
  }

  Future<void> _saveHabito(Habito habito) async {
    final file = await _getLocalFile();

    // Carregar a lista atual de hábitos
    List<Habito> currentHabitos = await _loadHabitos();

    // Adicionar o novo hábito
    currentHabitos.add(habito);

    // Converter toda a lista para JSON
    String jsonString = jsonEncode(currentHabitos.map((h) => h.toJson()).toList());

    // Salvar no arquivo
    await file.writeAsString(jsonString);
  }

  Future<List<Habito>> _loadHabitos() async {
    try {
      final file = await _getLocalFile();
      final contents = await file.readAsString();

      // Se o arquivo estiver vazio, retorna uma lista vazia
      if (contents.isEmpty) {
        return [];
      }

      // Converter o JSON para uma lista de hábitos
      List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Habito.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao carregar hábitos: $e');
      return [];
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/habitos.txt');
  }

}