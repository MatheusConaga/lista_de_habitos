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
        title: Text(widget.habit == null ? 'Adicionar Hábito' : 'Editar Hábito'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            DropdownButton<Frequencia>(
              value: _frequencia,
              onChanged: (Frequencia? newValue) {
                setState(() {
                  _frequencia = newValue!;
                });
              },
              items: Frequencia.values.map((Frequencia freq) {
                return DropdownMenuItem<Frequencia>(
                  value: freq,
                  child: Text(freq.toString().split('.').last),
                );
              }).toList(),
            ),
            // Adicione outros widgets para seleção de dias e conclusão, se necessário.
          ],
        ),
      ),
    );
  }
}
