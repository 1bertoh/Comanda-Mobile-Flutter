
import 'package:projeto_tutorial/dao/dao_entity.dart';

class StatusComanda implements DaoEntity {
  int codigo;
  String status;

  StatusComanda({
    required this.codigo,
    required this.status
  });

  StatusComanda.empty() : this(
    codigo: DaoEntity.idInvalido,
    status: '',
  );

  StatusComanda.fromMap(Map<String, Object?> map) : this(
    codigo: map['id'] as int,
    status: map['status'] as String,
  );

  @override
  void fromMap(Map<String, Object?> map) {
    codigo = map['codigo'] as int;
    status = map['status'] as String;
  }

  @override
  int get id => codigo;

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'codigo': codigo,
      'status': status,
    };
    return map;
  }
}
