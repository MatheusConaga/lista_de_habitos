enum Frequencia {
  diario,
  semanal,
  mensal,
}

class Habito {
  String nome;
  String descricao;
  Frequencia frequencia;

  Habito({
    required this.nome,
    required this.descricao,
    required this.frequencia,
  });

  // Converter um hábito para um mapa (para salvar como JSON)
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'frequencia': frequencia.name,
    };
  }

  // Criar um hábito a partir de um mapa (carregar de JSON)
  factory Habito.fromJson(Map<String, dynamic> json) {
    return Habito(
      nome: json['nome'],
      descricao: json['descricao'],
      frequencia: Frequencia.values.firstWhere((f) =>
      f.name == json['frequencia']),
    );
  }
}