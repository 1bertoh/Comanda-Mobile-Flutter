import 'package:flutter/cupertino.dart';
import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/dao/database_helper.dart';
import 'package:projeto_tutorial/dao/local_http/comanda_dao_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/comida_dao_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/mesa_dao_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/pedido_dao_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/status_comanda_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/tipo_comida_dao_local_http.dart';
import 'package:projeto_tutorial/dao/sqlite/funcionario_dao_sqlite.dart';
import 'package:projeto_tutorial/model/comanda.dart';
import 'package:projeto_tutorial/model/comercio.dart';

import 'package:path/path.dart';
import 'package:projeto_tutorial/model/comida.dart';
import 'package:projeto_tutorial/model/mesa.dart';
import 'package:projeto_tutorial/model/pedido.dart';
import 'package:projeto_tutorial/model/statusComanda.dart';
import 'package:projeto_tutorial/model/tipoComida.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperSqlite extends DatabaseHelper {
  static DatabaseHelperSqlite? _instance;
  static DatabaseHelperSqlite get instance {
    _instance ??= DatabaseHelperSqlite._();
    return _instance!;
  }
  DatabaseHelperSqlite._();

  FuncionarioDaoSqlite? _funcionarioDao;
  ComandaDaoLocalHttp? _comandaDao;
  ComidaDaoLocalHttp? _comidaDao;
  MesaDaoLocalHttp? _mesaDao;
  PedidoDaoLocalHttp? _pedidoDao;
  StatusComandaDaoLocalHttp? _statusComandaDao;
  TipoComidaDaoLocalHttp? _tipoComidaDao;

  @override
  Dao<Funcionario> get funcionarioDao {
    _funcionarioDao ??= FuncionarioDaoSqlite();
    return _funcionarioDao!;
  }

  @override
  Dao<Comanda> get comandaDao {
    _comandaDao ??= ComandaDaoLocalHttp();
    return _comandaDao!;
  }
  @override
  Dao<Comida> get comidaDao {
    _comidaDao ??= ComidaDaoLocalHttp();
    return _comidaDao!;
  }
  @override
  Dao<Mesa> get mesaDao {
    _mesaDao ??= MesaDaoLocalHttp();
    return _mesaDao!;
  }
  @override
  Dao<Pedido> get pedidoDao {
    _pedidoDao ??= PedidoDaoLocalHttp();
    return _pedidoDao!;
  }
  @override
  Dao<StatusComanda> get statusComandaDao {
    _statusComandaDao ??= StatusComandaDaoLocalHttp();
    return _statusComandaDao!;
  }
  @override
  Dao<TipoComida> get tipoComidaDao {
    _tipoComidaDao ??= TipoComidaDaoLocalHttp();
    return _tipoComidaDao!;
  }

  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      await iniciarDatabaseHelper();
    }
    if (_database == null) {
      throw Exception('Erro ao conectar com armazenamento de dados.');
    }
    return _database!;
  }

  @override
  Future<void> iniciarDatabaseHelper() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = await openDatabase(
      join(await getDatabasesPath(), 'comercio.db'),
      version: 1,
      onCreate: (db, version) => _criarBancoDeDados(db),
    );
  }

  static void _criarBancoDeDados(Database db) {
    db.execute('''
      CREATE TABLE Funcionario (
        codigo integer not null primary key autoincrement,
        nome text not null,
        cpf integer not null,
        endereco text not null,
        telefone text not null,
        email text not null,
        cargo text not null -- 'V': vendedor; 'C': comprador
      )''');
  }

}