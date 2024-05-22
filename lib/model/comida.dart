
import 'package:projeto_tutorial/dao/dao_entity.dart';

class Comida implements DaoEntity {
  int codigo;
  String nome;
  String descricao;
  double preco;
  int status;
  String imagem;
  double desconto;
  int tipo;

  Comida({
    required this.codigo,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.status,
    required this.imagem,
    required this.desconto,
    required this.tipo
  });

  Comida.empty() : this(
    codigo: DaoEntity.idInvalido,
    nome: '',
    descricao: '',
    preco: 0.00,
    status: 1,
    imagem: '',
    desconto: 0.00,
    tipo: 0
  );

  Comida.fromMap(Map<String, Object?> map) : this(
    codigo: map['id'] as int,
    nome: map['nome'] as String,
    descricao: map['descricao'] as String,
    preco: map['preco'] as double,
    status: map['status'] as int,
    imagem: map['imagem'] as String,
    desconto: map['desconto'] as double,
    tipo: map['id_tipo'] as int,
  );

  @override
  void fromMap(Map<String, Object?> map) {
    codigo = map['codigo'] as int;
    nome = map['nome'] as String;
    descricao = map['descricao'] as String;
    preco = map['preco'] as double;
    status = map['status'] as int;
    imagem = map['imagem'] as String;
    desconto = map['desconto'] as double;
    tipo = map['tipo'] as int;
  }

  @override
  int get id => codigo;

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'codigo': codigo,
      'nome': nome,
      "descricao": descricao,
      "preco": preco,
      "status": status,
      "imagem": imagem,
      "desconto": desconto,
      "tipo": tipo,
    };
    return map;
  }
}
