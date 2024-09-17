import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Frequencia _frequenciaSelecionada = Frequencia.diario;
  List<int> _diasSelecionados = [];

  final List<String> _diasSemana = [
    'Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'
  ];

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
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
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
                    final day = index; // Usar índice diretamente como o dia
                    return ChoiceChip(
                      label: Text(_diasSemana[index]),
                      selected: _diasSelecionados.contains(day),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            if (!_diasSelecionados.contains(day)) {
                              _diasSelecionados.add(day);
                            }
                          } else {
                            _diasSelecionados.remove(day);
                          }
                        });
                      },
                    );
                  }),
                ),
                if (_diasSelecionados.isNotEmpty)
                  Text('Dias selecionados: ${_formatDays(_diasSelecionados)}'),
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
                        _diasSelecionados = [selectedDate.day];
                      });
                    }
                  },
                  child: Text('Selecionar Data'),
                ),
                if (_diasSelecionados.isNotEmpty)
                  Text('Data selecionada: ${DateTime.now().copyWith(day: _diasSelecionados.first).toLocal()}'),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addHabit();
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

  void _addHabit() {
    final newHabit = Habit(
      name: _nomeController.text,
      descricao: _descricaoController.text,
      frequencia: _frequenciaSelecionada,
      days: List<int>.from(_diasSelecionados),
      isActive: true,
    );

    // Adiciona o novo hábito ao provedor
    final habitNotifier = ref.read(habitProvider.notifier);
    habitNotifier.addHabit(newHabit);

    Navigator.pop(context);
  }

  String _formatDays(List<int> days) {
    return days.map((d) => _diasSemana[d]).join(', ');
  }
}
