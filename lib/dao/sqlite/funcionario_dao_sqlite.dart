import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/dao/sqlite/database_helper_sqlite.dart';
import 'package:projeto_tutorial/model/comercio.dart';
import 'package:sqflite/sqflite.dart';

class FuncionarioDaoSqlite implements Dao<Funcionario> {
  static const tableName = 'Funcionario';
  static const columnCodigo = 'codigo';
  static const columnNome = 'nome';
  static const columnCpf = 'cpf';
  static const columnEndereco = 'endereco';
  static const columnTelefone = 'telefone';
  static const columnEmail = 'email';
  static const columnCargo = 'cargo';

  @override
  Future<bool> alterar(Funcionario item) async {
    Database db = await DatabaseHelperSqlite.instance.database;
    var linhasAfetadas = await db.update(
      tableName,
      <String, Object?>{
        columnNome: item.nome,
        columnCpf: item.cpf,
        columnEndereco: item.endereco,
        columnTelefone: item.telefone,
        columnEmail: item.email,
        columnCargo: item.cargo,
      },
      where: '$columnCodigo = ?',
      whereArgs: [item.id],
    );
    return linhasAfetadas == 1;
  }

  @override
  Future<bool> excluir(Funcionario item) async {
    Database db = await DatabaseHelperSqlite.instance.database;
    var linhasAfetadas = await db.delete(
      tableName,
      where: '$columnCodigo = ?',
      whereArgs: [item.id],
    );
    return linhasAfetadas == 1;
  }

  @override
  Future<bool> inserir(Funcionario item) async {
    Database db = await DatabaseHelperSqlite.instance.database;
    var id = await db.insert(
      tableName,
      <String, Object?>{
        columnNome: item.nome,
        columnCpf: item.cpf,
        columnEndereco: item.endereco,
        columnTelefone: item.telefone,
        columnEmail: item.email,
        columnCargo: item.cargo,
      },
    );
    if (id > 0) {
      item.codigo = id;
      return true;
    }
    return false;
  }

  @override
  Future<List<Funcionario>> listarTodos() async {
    Database db = await DatabaseHelperSqlite.instance.database;
    var mapList = await db.rawQuery('''
      select $columnCodigo, $columnNome, $columnCpf, $columnEndereco, 
             $columnTelefone, $columnEmail, $columnCargo
      from $tableName
      order by $columnNome asc
    ''');
    var listFuncionario = mapList.map<Funcionario>((f) => Funcionario.fromMap(f)).toList();
    return listFuncionario;
  }

  @override
  Future<Funcionario?> selecionarPorId(int id) async {
    Database db = await DatabaseHelperSqlite.instance.database;
    var mapList = await db.rawQuery('''
      select $columnCodigo, $columnNome, $columnCpf, $columnEndereco, 
             $columnTelefone, $columnEmail, $columnCargo
      from $tableName
      where $columnCodigo = ?
      order by $columnNome asc
    ''', [id]);
    var funcionario = Funcionario.fromMap(mapList.first);
    return funcionario;
  }
}
