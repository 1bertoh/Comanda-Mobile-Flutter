
import 'package:projeto_tutorial/dao/dao_entity.dart';

class Comanda implements DaoEntity {
  int codigo;
  int idMesa;
  int idStatus;
  String createdAt;
  double valor;
  double desconto;
  String observacao;

  Comanda({
    required this.codigo,
    required this.idMesa,
    required this.idStatus,
    required this.createdAt,
    required this.valor,
    required this.desconto,
    required this.observacao
  });

  Comanda.empty() : this(
      codigo: DaoEntity.idInvalido,
      idMesa: 0,
      idStatus: 0,
      createdAt: '',
      valor: 0.00,
      desconto: 0.00,
      observacao: ''
  );

  Comanda.fromMap(Map<String, Object?> map) : this(
    codigo: map['id'] as int,
    idMesa: map['id_mesa'] as int,
    idStatus: map['id_status'] as int,
    createdAt: map['create_at'] as String,
    valor: map['valor'] as double,
    desconto: map['desconto'] as double,
    observacao: map['observacao'] as String,
  );

  @override
  void fromMap(Map<String, Object?> map) {
    codigo = map['codigo'] as int;
    idMesa= map['idMesa'] as int;
    idStatus= map['idStatus'] as int;
    createdAt= map['createdAt'] as String;
    valor= map['valor'] as double;
    desconto= map['desconto'] as double;
    observacao= map['observacao'] as String;
  }

  @override
  int get id => codigo;

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'codigo': codigo,
      'idMesa': idMesa,
      "idStatus": idStatus,
      "createdAt": createdAt,
      "valor": valor,
      "desconto": desconto,
      "observacao": observacao,
    };
    return map;
  }
}
