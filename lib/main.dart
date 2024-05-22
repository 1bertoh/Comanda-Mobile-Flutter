import 'package:flutter/material.dart';
import 'package:projeto_tutorial/dao/database_helper.dart';
import 'package:projeto_tutorial/dao/local_http/database_helper_local_http.dart';
import 'package:projeto_tutorial/dao/sqlite/database_helper_sqlite.dart';
import 'package:projeto_tutorial/pages/menu_inicial.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  AppTutorial.runPreLoadProcedureLocalHttp();
  runApp(const AppTutorial());
}

class AppTutorial extends StatelessWidget {
  static void runPreLoadProcedureSqlite() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    DatabaseHelper.instance = DatabaseHelperSqlite.instance;
  }

  static void runPreLoadProcedureLocalHttp() {
    DatabaseHelper.instance = DatabaseHelperLocalHttp.instance;
  }

  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  const AppTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      title: 'Tutorial',
      theme: ThemeData.dark(
        useMaterial3: true
      ),
      home: const MenuInicial(),
    );
  }
}
