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
  late List<int> _days; // Para hábitos semanais
  DateTime? _selectedDate; // Para hábitos mensais
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _descricaoController = TextEditingController(text: widget.habit?.descricao ?? '');
    _frequencia = widget.habit?.frequencia ?? Frequencia.diario;
    _days = widget.habit?.days ?? [];
    _selectedDate = widget.habit?.days.isNotEmpty == true
        ? DateTime(DateTime.now().year, widget.habit!.days.first)
        : null;
    _isCompleted = widget.habit?.isCompleted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.habit == null ? 'Adicionar Hábito' : 'Editar Hábito',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                ),
              ),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                ),
              ),
              DropdownButton<Frequencia>(
                value: _frequencia,
                onChanged: (Frequencia? newValue) {
                  setState(() {
                    _frequencia = newValue!;
                    _days.clear();
                    _selectedDate = null;
                  });
                },
                dropdownColor: Colors.white,
                items: Frequencia.values.map((Frequencia freq) {
                  return DropdownMenuItem<Frequencia>(
                    value: freq,
                    child: Text(freq.toString().split('.').last),
                  );
                }).toList(),
              ),
              if (_frequencia == Frequencia.semanal) ...[
                Text('Selecione os dias da semana:'),
                Wrap(
                  spacing: 8.0,
                  children: List<Widget>.generate(7, (int index) {
                    return ChoiceChip(
                      label: Text(_getDayName(index + 1)),
                      selected: _days.contains(index + 1),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _days.add(index + 1);
                          } else {
                            _days.remove(index + 1);
                          }
                        });
                      },
                    );
                  }),
                ),
              ] else if (_frequencia == Frequencia.mensal) ...[
                Text('Selecione uma data:'),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Nenhuma data selecionada'
                            : _formatDate(_selectedDate!),
                        style: TextStyle(
                          color: _selectedDate == null ? Colors.red : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.blue),
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
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final habit = Habit(
                      id: widget.habit?.id,
                      name: _nameController.text,
                      descricao: _descricaoController.text,
                      frequencia: _frequencia,
                      days: _frequencia == Frequencia.mensal && _selectedDate != null
                          ? [_selectedDate!.day] // Apenas o dia selecionado para mensal
                          : _days,
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
                  child: Text(widget.habit == null ? 'Adicionar Hábito' : 'Salvar Alterações'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  String _formatDate(DateTime date) {
    // Formata a data como 'Quarta-feira, 4 de Setembro de 2024'
    final dayOfWeek = _getDayName(date.weekday);
    final month = _getMonthName(date.month);
    return '$dayOfWeek, ${date.day} de $month de ${date.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Janeiro';
      case 2:
        return 'Fevereiro';
      case 3:
        return 'Março';
      case 4:
        return 'Abril';
      case 5:
        return 'Maio';
      case 6:
        return 'Junho';
      case 7:
        return 'Julho';
      case 8:
        return 'Agosto';
      case 9:
        return 'Setembro';
      case 10:
        return 'Outubro';
      case 11:
        return 'Novembro';
      case 12:
        return 'Dezembro';
      default:
        return '';
    }
  }
}
