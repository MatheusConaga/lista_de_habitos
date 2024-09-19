import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  final Habit? habit;

  const AddHabitScreen({Key? key, this.habit}) : super(key: key);

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descricaoController;
  Frequencia _frequencia = Frequencia.diario;
  late List<int> _days;
  bool _isCompleted = false;
  DateTime? _selectedDate;  // Variável para armazenar a data selecionada

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _nameController = TextEditingController(text: widget.habit!.name);
      _descricaoController = TextEditingController(text: widget.habit!.descricao);
      _frequencia = widget.habit!.frequencia;
      _days = widget.habit!.days;
      _isCompleted = widget.habit!.isCompleted;
    } else {
      _nameController = TextEditingController();
      _descricaoController = TextEditingController();
      _days = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Adicionar Hábito' : 'Editar Hábito', style: TextStyle(color: Colors.white)), // Cor do título da AppBar
        backgroundColor: Colors.blue, // Cor de fundo da AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white), // Cor do ícone na AppBar
            onPressed: () {
              final habit = Habit(
                id: widget.habit?.id,
                name: _nameController.text,
                descricao: _descricaoController.text,
                frequencia: _frequencia,
                days: _days,
                completedDays: widget.habit?.completedDays ?? [],
                isCompleted: _isCompleted,
              );

              if (widget.habit == null) {
                ref.read(habitProvider.notifier).addHabit(habit);
              } else {
                ref.read(habitProvider.notifier).removeHabit(widget.habit!.id);
                ref.read(habitProvider.notifier).addHabit(habit);
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.blue, // Cor de fundo do Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                labelStyle: TextStyle(color: Colors.white), // Cor do texto do label
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Cor da linha inferior quando o campo está focado
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Cor da linha inferior do campo
                ),
              ),
              style: TextStyle(color: Colors.white), // Cor do texto do campo
            ),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                labelStyle: TextStyle(color: Colors.white), // Cor do texto do label
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Cor da linha inferior quando o campo está focado
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Cor da linha inferior do campo
                ),
              ),
              style: TextStyle(color: Colors.white), // Cor do texto do campo
            ),
            DropdownButton<Frequencia>(
              value: _frequencia,
              onChanged: (Frequencia? newValue) {
                setState(() {
                  _frequencia = newValue!;
                  _days.clear();  // Limpa os dias ao mudar a frequência

                  // Se a frequência for mensal, limpar a data anterior
                  if (_frequencia != Frequencia.mensal) {
                    _selectedDate = null;
                  }
                });
              },
              dropdownColor: Colors.blue, // Cor de fundo do DropdownButton
              style: TextStyle(color: Colors.white), // Cor do texto do DropdownButton
              items: Frequencia.values.map((Frequencia freq) {
                return DropdownMenuItem<Frequencia>(
                  value: freq,
                  child: Text(freq.toString().split('.').last),
                );
              }).toList(),
            ),
            if (_frequencia == Frequencia.semanal) ...[
              Text('Selecione os dias da semana:', style: TextStyle(color: Colors.white)), // Cor do texto
              ..._buildDayCheckboxes(),
            ] else if (_frequencia == Frequencia.mensal) ...[
              Text('Selecione uma data:', style: TextStyle(color: Colors.white)), // Cor do texto
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Nenhuma data selecionada'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: TextStyle(color: Colors.white), // Cor do texto
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.white), // Cor do ícone
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDayCheckboxes() {
    return List.generate(7, (index) {
      final day = index + 1;
      return CheckboxListTile(
        title: Text(_getDayName(day), style: TextStyle(color: Colors.white)), // Cor do texto
        value: _days.contains(day),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _days.add(day);
            } else {
              _days.remove(day);
            };
          });
        },
        activeColor: Colors.blue, // Cor do Checkbox quando ativo
        checkColor: Colors.white, // Cor do ícone de check
      );
    });
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return 'Segunda-feira';
      case 2:
        return 'Terça-feira';
      case 3:
        return 'Quarta-feira';
      case 4:
        return 'Quinta-feira';
      case 5:
        return 'Sexta-feira';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }
}
