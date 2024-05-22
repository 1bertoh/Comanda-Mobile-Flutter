
import 'package:projeto_tutorial/dao/dao_entity.dart';

class TipoComida implements DaoEntity {
  int codigo;
  String nome;

  TipoComida({
    required this.codigo,
    required this.nome
  });

  TipoComida.empty() : this(
      codigo: DaoEntity.idInvalido,
      nome: '',
  );

  TipoComida.fromMap(Map<String, Object?> map) : this(
    codigo: map['codigo'] as int,
    nome: map['nome'] as String,
  );

  @override
  void fromMap(Map<String, Object?> map) {
    codigo = map['codigo'] as int;
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
