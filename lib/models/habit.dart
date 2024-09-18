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
  }) : id = id ?? Uuid().v4(); // Se o id não for passado, gera um novo ID.

  Habit copyWith({
    String? id,
    String? name,
    String? descricao,
    Frequencia? frequencia,
    List<int>? days,
    List<int>? completedDays,
    bool? isCompleted,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      descricao: descricao ?? this.descricao,
      frequencia: frequencia ?? this.frequencia,
      days: days ?? this.days,
      completedDays: completedDays ?? this.completedDays,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
