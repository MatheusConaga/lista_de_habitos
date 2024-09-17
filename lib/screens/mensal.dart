import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:monitoramento_de_habitos/models/habito_model.dart';

class MensalScreen extends StatefulWidget {
  const MensalScreen({super.key});

  @override
  _MensalScreenState createState() => _MensalScreenState();
}

class _MensalScreenState extends State<MensalScreen> {
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
        title: Text('Lista de Hábitos Mensais'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: habitos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(habitos[index].name),
              subtitle: Text(
                'Descrição: ${habitos[index].descricao}\nFrequência: ${habitos[index].frequencia.name}',
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteHabito(index);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _deleteHabito(int index) async {
    setState(() {
      habitos.removeAt(index);
    });

    // Atualiza o armazenamento local
    _saveAllHabitos();
  }

  Future<void> _saveAllHabitos() async {
    final file = await _getLocalFile();

    // Converter a lista atual para JSON
    String jsonString = jsonEncode(habitos.map((h) => h.toJson()).toList());

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
