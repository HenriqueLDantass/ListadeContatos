class Pessoa {
  String? objectId;
  String nome;
  String numero;
  String fotoPath;

  Pessoa({
    this.objectId,
    required this.nome,
    required this.numero,
    required this.fotoPath,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      objectId: json['objectId'] ?? "",
      nome: json['nome'] ?? "",
      numero: json['numero'] ?? "",
      fotoPath: json['fotoPath'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'numero': numero,
      'fotoPath': fotoPath,
    };
  }
}
