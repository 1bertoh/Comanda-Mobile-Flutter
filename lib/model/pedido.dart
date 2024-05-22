
import 'package:projeto_tutorial/dao/dao_entity.dart';

class Pedido implements DaoEntity {
  int codigo;
  int idComanda;
  int idComida;
  String status;
  String observacao;
  String createAt;

  Pedido({
    required this.codigo,
    required this.idComanda,
    required this.idComida,
    required this.status,
    required this.observacao,
    required this.createAt,
  });

  Pedido.empty() : this(
      codigo: DaoEntity.idInvalido,
      idComanda: 0,
      idComida: 0,
      status: '',
      observacao: '',
      createAt: ''
  );

  Pedido.fromMap(Map<String, Object?> map) : this(
    codigo: map['id'] as int,
    idComanda: map['id_comanda'] as int,
    idComida: map['id_comida'] as int,
    status: map['status'] as String,
    observacao: map['observacao'] as String,
    createAt: map['create_at'] as String
  );

  @override
  void fromMap(Map<String, Object?> map) {
    codigo = map['codigo'] as int;
    idComanda= map['idComanda'] as int;
    idComida= map['idComida'] as int;
    status= map['status'] as String;
    observacao= map['observacao'] as String;
    createAt= map['createAt'] as String;
  }

  @override
  int get id => codigo;

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'codigo': codigo,
      'idComanda': idComanda,
      "idComida": idComida,
      "status": status,
      "observacao": observacao,
      "createAt": createAt,
    };
    return map;
  }
}
