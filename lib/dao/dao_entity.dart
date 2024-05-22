
abstract class DaoEntity {
  static int idInvalido = -1;
  int get id;
  void fromMap(Map<String, Object?> map);
  Map<String, Object?> toMap();
}
