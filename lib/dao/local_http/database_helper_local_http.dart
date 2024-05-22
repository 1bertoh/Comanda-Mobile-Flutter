
import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/dao/database_helper.dart';
import 'package:projeto_tutorial/dao/local_http/comanda_dao_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/comida_dao_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/funcionario_dao_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/mesa_dao_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/pedido_dao_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/status_comanda_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/tipo_comida_dao_local_http.dart';
import 'package:projeto_tutorial/model/comanda.dart';
import 'package:projeto_tutorial/model/comercio.dart';
import 'package:projeto_tutorial/model/comida.dart';
import 'package:projeto_tutorial/model/mesa.dart';
import 'package:projeto_tutorial/model/pedido.dart';
import 'package:projeto_tutorial/model/statusComanda.dart';
import 'package:projeto_tutorial/model/tipoComida.dart';

class DatabaseHelperLocalHttp extends DatabaseHelper {
  static DatabaseHelperLocalHttp? _instance;
  static DatabaseHelperLocalHttp get instance {
    _instance ??= DatabaseHelperLocalHttp._();
    return _instance!;
  }
  DatabaseHelperLocalHttp._();

  FuncionarioDaoLocalHttp? _funcionarioDao;
  ComandaDaoLocalHttp? _comandaDao;
  ComidaDaoLocalHttp? _comidaDao;
  MesaDaoLocalHttp? _mesaDao;
  PedidoDaoLocalHttp? _pedidoDao;
  StatusComandaDaoLocalHttp? _statusComandaDao;
  TipoComidaDaoLocalHttp? _tipoComidaDao;

  @override
  Dao<Funcionario> get funcionarioDao {
    _funcionarioDao ??= FuncionarioDaoLocalHttp();
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

  @override
  Future<void> iniciarDatabaseHelper() async {}

}