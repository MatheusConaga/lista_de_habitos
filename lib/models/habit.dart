import 'package:uuid/uuid.dart';

enum Frequencia { diario, semanal, mensal }

class Habit {
  final String id;
  final String name;
  final String descricao;
  final Frequencia frequencia;
  final List<int> days;
  final List<int> completedDays;
  final bool isCompleted;

  Habit({
    String? id,
    required this.name,
    required this.descricao,
    required this.frequencia,
    required this.days,
    this.completedDays = const [],
    this.isCompleted = false,
  }) : id = id ?? Uuid().v4();

  // Conversão para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descricao': descricao,
      'frequencia': frequencia.index,
      'days': days,
      'completedDays': completedDays,
      'isCompleted': isCompleted,
    };
  }

  // Conversão de JSON
  static Habit fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      descricao: json['descricao'],
      frequencia: Frequencia.values[json['frequencia']],
      days: List<int>.from(json['days']),
      completedDays: List<int>.from(json['completedDays']),
      isCompleted: json['isCompleted'],
    );
  }

  // Método copyWith
  Habit copyWith({
    String? name,
    String? descricao,
    Frequencia? frequencia,
    List<int>? days,
    List<int>? completedDays,
    bool? isCompleted,
  }) {
    return Habit(
      id: this.id,
      name: name ?? this.name,
      descricao: descricao ?? this.descricao,
      frequencia: frequencia ?? this.frequencia,
      days: days ?? this.days,
      completedDays: completedDays ?? this.completedDays,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
