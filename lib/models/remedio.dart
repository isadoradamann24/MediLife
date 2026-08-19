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


  // Pega os dados do banco e transforma em objeto Remedio
  Remedio.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        nome = res["nome"],
        quantidade = res["quantidade"],
        horario = res["horario"],
        motivo = res["motivo"],
        dias = res["dias"],
        tomou = res["tomou"];


  // Transforma o objeto Remedio em dados para salvar no banco
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "nome": nome,
      "quantidade": quantidade,
      "horario": horario,
      "motivo": motivo,
      "dias": dias,
      "tomou": tomou,
    };
  }
}