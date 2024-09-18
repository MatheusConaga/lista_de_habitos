import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  final Habit? habit; // Adiciona o parâmetro habit opcional

  const AddHabitScreen({super.key, this.habit}); // Inicializa o parâmetro habit

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final TextEditingController _nomeInputController = TextEditingController();
  final TextEditingController _descricaoInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Frequencia _frequenciaSelecionada = Frequencia.diario;

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _nomeInputController.text = widget.habit!.name;
      _descricaoInputController.text = widget.habit!.descricao;
      _frequenciaSelecionada = widget.habit!.frequencia;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Adicionar Hábito' : 'Editar Hábito'),
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
                  });
                },
                decoration: InputDecoration(labelText: 'Frequência'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.habit == null) {
                      _doAdd();
                    } else {
                      _doUpdate();
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.habit == null ? 'Adicionar Hábito' : 'Atualizar Hábito'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _doAdd() {
    Habit newHabit = Habit(
      name: _nomeInputController.text,
      descricao: _descricaoInputController.text,
      frequencia: _frequenciaSelecionada,
      days: [],
    );
    ref.read(habitProvider.notifier).addHabit(newHabit);
  }

  void _doUpdate() {
    if (widget.habit != null) {
      Habit updatedHabit = widget.habit!.copyWith(
        name: _nomeInputController.text,
        descricao: _descricaoInputController.text,
        frequencia: _frequenciaSelecionada,
      );
      ref.read(habitProvider.notifier).updateHabit(updatedHabit);
    }
  }
}
