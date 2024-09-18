import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoramento_de_habitos/screens/semanal.dart';
import 'package:monitoramento_de_habitos/screens/mensal.dart'; // Importe a tela MensalScreen
import 'package:percent_indicator/percent_indicator.dart';  // Import correto
import 'package:monitoramento_de_habitos/screens/add_habit_screen.dart';
import 'package:monitoramento_de_habitos/screens/diario.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoramento de Hábitos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHabitCard(context, 'Diário', 0.26), // Progresso de 26%
              SizedBox(height: 16), // Espaçamento entre os cards
              _buildHabitCard(context, 'Semanal', 0.26),
              SizedBox(height: 16),
              _buildHabitCard(context, 'Mensal', 0.26),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a tela de adicionar hábito
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHabitScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Função para criar um Card com título e barra de progresso circular
  Widget _buildHabitCard(BuildContext context, String title, double percent) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (title == 'Diário') {
            // Navegar para a tela Diário ao clicar em "Diário"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DiarioScreen()), // Corrigido para DiárioScreen
            );
          } else if (title == 'Semanal') {
            // Navegar para a tela Semanal ao clicar em "Semanal"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SemanalScreen()),
            );
          } else if (title == 'Mensal') {
            // Navegar para a tela Mensal ao clicar em "Mensal"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MensalScreen()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircularPercentIndicator(
                radius: 60.0, // Tamanho do círculo
                lineWidth: 8.0, // Largura da barra
                percent: percent, // Percentual de progresso (0.26 = 26%)
                center: Text(
                  '${(percent * 100).toInt()}%', // Exibe o percentual
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                progressColor: Colors.green, // Cor da barra de progresso
                backgroundColor: Colors.grey.shade300, // Cor do fundo da barra
                circularStrokeCap: CircularStrokeCap.round, // Estilo da barra
              ),
            ],
          ),
        ),
      ),
    );
  }
}
