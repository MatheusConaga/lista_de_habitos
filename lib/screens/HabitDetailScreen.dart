import 'package:flutter/material.dart';
import 'package:monitoramento_de_habitos/models/habit.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habito;

  const HabitDetailScreen({super.key, required this.habito});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes do Hábito',
          style: TextStyle(color: Colors.white
          ),
        ),
        backgroundColor: Colors.blue, // AppBar azul
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[200], // Fundo cinza claro
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDetailRow('Nome:', habito.name),
              SizedBox(height: 8.0),
              _buildDetailRow('Descrição:', habito.descricao),
              SizedBox(height: 8.0),
              _buildDetailRow('Frequência:', habito.frequencia.name),
              SizedBox(height: 8.0),
              if (habito.frequencia == Frequencia.semanal)
                _buildDetailRow('Dias da Semana:', _formatDays(habito.days)),
              if (habito.frequencia == Frequencia.mensal)
                _buildDetailRow('Dia do Mês:', _formatDayOfMonth(habito.days)),
              SizedBox(height: 16.0),
              if (habito.isCompleted)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hábito Concluído!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDays(List<int> days) {
    return days.map((day) => _getDayName(day)).join(', ');
  }

  String _formatDayOfMonth(List<int> days) {
    return days.isNotEmpty ? days.first.toString() : 'Nenhum dia selecionado';
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
