
import 'package:projeto_tutorial/dao/dao_entity.dart';

class Mesa implements DaoEntity {
  int codigo;
  String nome;

  Mesa({
    required this.codigo,
    required this.nome,
  });

  Mesa.empty() : this(
    codigo: DaoEntity.idInvalido,
    nome: '',

  );

  Mesa.fromMap(Map<String, Object?> map) : this(
    codigo: map['id'] as int,
    nome: map['nome'] as String,
  );

  @override
  void fromMap(Map<String, Object?> map) {
    codigo = map['id'] as int;
    nome = map['nome'] as String;
  }

  @override
  int get id => codigo;

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'codigo': codigo,
      'nome': nome,
    };
    return map;
  }
}
