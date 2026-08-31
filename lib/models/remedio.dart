class Remedio {
  final int? id;
  final String nome;
  final int quantidade;
  final String horario;
  final String motivo;
  final String dias;

  Remedio({
    this.id,
    required this.nome,
    required this.quantidade,
    required this.horario,
    required this.motivo,
    required this.dias,
  });

  factory Remedio.fromMap(Map<String, dynamic> res) {
    return Remedio(
      id: res['id'] as int?,
      nome: res['nome'] as String? ?? '',
      quantidade: res['quantidade'] as int? ?? 0,
      horario: res['horario'] as String? ?? '',
      motivo: res['motivo'] as String? ?? '',
      dias: res['dias'] as String? ?? '',
    );
  }

  Map<String, Object?> toMap() {
    return {
      'nome': nome,
      'quantidade': quantidade,
      'horario': horario,
      'motivo': motivo,
      'dias': dias,
    };
  }
}