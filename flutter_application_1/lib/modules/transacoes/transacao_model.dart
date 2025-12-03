class Transacao {
  final int? id;
  final String descricao;
  final double valor;
  final String data; 
  final int tipo; // 0 = Despesa, 1 = Receita

  Transacao({
    this.id,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'valor': valor,
      'data': data,
      'tipo': tipo,
    };
  }

  factory Transacao.fromMap(Map<String, dynamic> map) {
    return Transacao(
      id: map['id'],
      descricao: map['descricao'],
      valor: map['valor'],
      data: map['data'],
      tipo: map['tipo'],
    );
  }
}