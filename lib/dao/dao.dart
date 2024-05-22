import 'package:projeto_tutorial/dao/dao_entity.dart';

abstract interface class Dao<T extends DaoEntity> {
  Future<List<T>> listarTodos();
  Future<T?> selecionarPorId(int id);
  Future<bool> inserir(T item);
  Future<bool> alterar(T item);
  Future<bool> excluir(T item);
}
