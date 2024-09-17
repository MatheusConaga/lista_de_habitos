import 'package:uuid/uuid.dart';

enum Frequencia {
  diario,
  semanal,
  mensal, diaria,
}

class Habito {
  String id;
  String name;
  String descricao;
  Frequencia frequencia;
  List<int> days; // Supondo que os dias da semana são representados como inteiros (0-6)
  bool isActive;

  Habito({
    required this.name,
    required this.descricao,
    required this.frequencia,
    required this.days,
    this.isActive = true,
  }) : id = Uuid().v4(); // Gera um ID único para cada hábito

  // Converter um hábito para um mapa (para salvar como JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descricao': descricao,
      'frequencia': frequencia.name,
      'days': days,
      'isActive': isActive,
    };
  }

  // Criar um hábito a partir de um mapa (carregar de JSON)
  factory Habito.fromJson(Map<String, dynamic> json) {
    return Habito(
      name: json['name'],
      descricao: json['descricao'],
      frequencia: Frequencia.values.firstWhere((f) => f.name == json['frequencia']),
      days: List<int>.from(json['days']),
      isActive: json['isActive'] ?? true,
    );
  }

  set concluido(bool concluido) {}
}
