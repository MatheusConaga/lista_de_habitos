import 'package:uuid/uuid.dart';

enum Frequencia {
  diario,
  semanal,
  mensal,
}

class Habit {
  String id;
  String name;
  String descricao;
  Frequencia frequencia;
  List<int> days; // Lista dos dias da semana
  List<int> completedDays; // Lista dos dias do mês em que o hábito foi completado
  bool isActive;
  bool isCompleted;

  Habit({
    required this.name,
    required this.descricao,
    required this.frequencia,
    required this.days,
    this.completedDays = const [], // Inicializa com uma lista vazia
    this.isActive = true,
    this.isCompleted = false, // Inicializa como não concluído
  }) : id = Uuid().v4(); // Gera um ID único automaticamente

  // Converter um hábito para um mapa (para salvar como JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descricao': descricao,
      'frequencia': frequencia.name,
      'days': days,
      'completedDays': completedDays,
      'isActive': isActive,
      'isCompleted': isCompleted,
    };
  }

  // Criar um hábito a partir de um mapa (carregar de JSON)
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      name: json['name'],
      descricao: json['descricao'],
      frequencia: Frequencia.values.firstWhere((f) => f.name == json['frequencia']),
      days: List<int>.from(json['days']),
      completedDays: List<int>.from(json['completedDays'] ?? []),
      isActive: json['isActive'] ?? true,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Método copyWith para criar uma cópia com algumas alterações
  Habit copyWith({
    String? name,
    String? descricao,
    Frequencia? frequencia,
    List<int>? days,
    List<int>? completedDays,
    bool? isActive,
    bool? isCompleted,
  }) {
    return Habit(
      name: name ?? this.name,
      descricao: descricao ?? this.descricao,
      frequencia: frequencia ?? this.frequencia,
      days: days ?? this.days,
      completedDays: completedDays ?? this.completedDays,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
