import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/model/comanda.dart';
import 'package:projeto_tutorial/model/comercio.dart';
import 'package:projeto_tutorial/model/comida.dart';
import 'package:projeto_tutorial/model/mesa.dart';
import 'package:projeto_tutorial/model/pedido.dart';
import 'package:projeto_tutorial/model/statusComanda.dart';
import 'package:projeto_tutorial/model/tipoComida.dart';

abstract class DatabaseHelper {
  static late DatabaseHelper instance;

  Dao<Funcionario> get funcionarioDao;
  Dao<Comanda> get comandaDao;
  Dao<Comida> get comidaDao;
  Dao<Mesa> get mesaDao;
  Dao<Pedido> get pedidoDao;
  Dao<StatusComanda> get statusComandaDao;
  Dao<TipoComida> get tipoComidaDao;

  Future<void> iniciarDatabaseHelper();
}
