import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';
import 'package:monitoramento_de_habitos/providers/habit_provider.dart';
import 'package:monitoramento_de_habitos/screens/add_habit_screen.dart';
import 'package:monitoramento_de_habitos/screens/habitDetailScreen.dart';

class MensalScreen extends ConsumerWidget {
  const MensalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtém a lista de hábitos com frequência mensal
    final habitosMensais = ref.watch(habitProvider).where((habit) {
      return habit.frequencia == Frequencia.mensal;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.blue, // Cor de fundo da tela
      appBar: AppBar(
        title: Text('Hábitos Mensais', style: TextStyle(color: Colors.white)), // Cor do título da AppBar
        backgroundColor: Colors.blue, // Cor de fundo da AppBar
        iconTheme: IconThemeData(color: Colors.white), // Define a cor do botão de voltar como branco
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white), // Cor do ícone na AppBar
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddHabitScreen(), // Navega para a tela de adicionar
                ),
              );
            },
          ),
        ],
      ),
      body: habitosMensais.isEmpty
          ? Center(
        child: Text(
          'Nenhum hábito mensal encontrado.',
          style: TextStyle(color: Colors.white), // Cor do texto quando não há hábitos
        ),
      )
          : ListView.builder(
        itemCount: habitosMensais.length,
        itemBuilder: (context, index) {
          final habit = habitosMensais[index];
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.delete, color: Colors.red), // Cor do ícone de deletar
              onPressed: () {
                ref.read(habitProvider.notifier).removeHabit(habit.id); // Remove o hábito usando o ID
              },
            ),
            title: Text(
              habit.name,
              style: TextStyle(color: Colors.white), // Cor do título do hábito
            ),
            subtitle: Text(
              '${habit.descricao}\nDias completados: ${habit.completedDays.join(', ')}',
              style: TextStyle(color: Colors.white), // Cor do subtítulo
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white), // Cor do ícone de editar
                  onPressed: () {
                    // Navega para a tela de adicionar/editar hábito
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddHabitScreen(
                          habit: habit, // Passa o hábito para a tela de adicionar/editar
                        ),
                      ),
                    ).then((_) {
                      // Atualiza a tela após a edição do hábito
                      ref.refresh(habitProvider);
                    });
                  },
                ),
                Checkbox(
                  value: habit.isCompleted,
                  onChanged: (bool? value) {
                    if (value != null) {
                      ref.read(habitProvider.notifier).toggleHabitCompletion(habit.id); // Usa o ID do hábito
                    }
                  },
                  checkColor: Colors.white, // Cor do ícone de check quando o item está completo
                  activeColor: Colors.blue, // Cor do checkbox quando ativo
                ),
              ],
            ),
            onTap: () {
              // Navega para a tela de detalhes do hábito
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitDetailScreen(habito: habit), // Passa o hábito para a tela de detalhes
                ),
              );
            },
          );
        },
      ),
    );
  }
}
