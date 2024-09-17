import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:monitoramento_de_habitos/models/habito_model.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _nomeInputController = TextEditingController();
  final TextEditingController _descricaoInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Frequencia _frequenciaSelecionada = Frequencia.diario;
  List<int> _diasSelecionados = [];
  final List<String> _diasSemana = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Hábito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
                    _diasSelecionados.clear(); // Limpar dias selecionados ao mudar a frequência
                  });
                },
                decoration: InputDecoration(labelText: 'Frequência'),
              ),
              if (_frequenciaSelecionada == Frequencia.semanal) ...[
                Text('Selecione os dias da semana:'),
                Wrap(
                  spacing: 8.0,
                  children: List<Widget>.generate(7, (index) {
                    return ChoiceChip(
                      label: Text(_diasSemana[index]),
                      selected: _diasSelecionados.contains(index),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            if (!_diasSelecionados.contains(index)) {
                              _diasSelecionados.add(index);
                            }
                          } else {
                            _diasSelecionados.remove(index);
                          }
                        });
                      },
                    );
                  }),
                ),
              ] else if (_frequenciaSelecionada == Frequencia.mensal) ...[
                ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        _diasSelecionados = [selectedDate.millisecondsSinceEpoch];
                      });
                    }
                  },
                  child: Text('Selecionar Data'),
                ),
                if (_diasSelecionados.isNotEmpty)
                  Text('Data selecionada: ${DateTime.fromMillisecondsSinceEpoch(_diasSelecionados.first)}'),
              ],
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
      ),
    );
  }

  void _doAdd() {
    Habito newHabito = Habito(
      name: _nomeInputController.text,
      descricao: _descricaoInputController.text,
      frequencia: _frequenciaSelecionada,
      days: _diasSelecionados,
    );

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
