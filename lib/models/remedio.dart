class Remedio {
  final int? id;

  final String nome;

  final int quantidade;

  final String horario;

  final String motivo;

  final String dias;

  final int tomou;

  Remedio({
    this.id,

    required this.nome,

    required this.quantidade,

    required this.horario,

    required this.motivo,

    required this.dias,

    required this.tomou,
  });

  // Banco -> Objeto Dart

  factory Remedio.fromMap(Map<String, dynamic> res) {
    return Remedio(
      id: res["id"],

      nome: res["nome"] ?? "",

      quantidade: res["quantidade"] ?? 0,

      horario: res["horario"] ?? "",

      motivo: res["motivo"] ?? "",

      dias: res["dias"] ?? "",

      tomou: res["tomou"] ?? 0,
    );
  }

  // Objeto Dart -> Banco

  Map<String, Object?> toMap() {
    return {
      // Não precisa enviar o id
      // SQLite cria automaticamente

      "nome": nome,

      "quantidade": quantidade,

      "horario": horario,

      "motivo": motivo,

      "dias": dias,

      "tomou": tomou,
    };
  }
}
