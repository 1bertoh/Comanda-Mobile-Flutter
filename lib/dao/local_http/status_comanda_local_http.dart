import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/model/comanda.dart';
import 'dart:io' show Platform;

import 'package:projeto_tutorial/model/statusComanda.dart';

class StatusComandaDaoLocalHttp implements Dao<StatusComanda> {

  static String hostServidor = (!kIsWeb && Platform.isAndroid) ? 'servidor-comanda-mobile.humbertojunior3.repl.co' : 'localhost';
  static const portaServidor = 443;
  static const nomeEntidade = 'statuscomanda';

  @override
  Future<bool> alterar(StatusComanda item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidade, {
      'codigo': item.id,
      'status': item.status,
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      if (mapList.isNotEmpty) {
        var sucesso = mapList[0]['sucesso'];
        if (sucesso != null && sucesso! == 1) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Future<bool> excluir(StatusComanda item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidade, {
      'id': item.codigo,
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      if (mapList.isNotEmpty) {
        var sucesso = mapList[0]['sucesso'];
        if (sucesso != null && sucesso! == 1) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Future<bool> inserir(StatusComanda item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidade, {
      'codigo': item.id,
      'status': item.status,
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      if (mapList.isNotEmpty) {
        var codigo = mapList[0]['id'];
        if (codigo != null && codigo! >= 0) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Future<List<StatusComanda>> listarTodos() async {
    List<StatusComanda> lista = [];
    var url = Uri.https('$hostServidor:$portaServidor', nomeEntidade);
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes));
      for (var map in mapList) {
        var sc = StatusComanda.fromMap(map);
        lista.add(sc);
      }
    } else {
      print('Erro no status code: ${response.statusCode}');
    }
    return lista;
  }

  @override
  Future<StatusComanda?> selecionarPorId(int id) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidade, {
      'id': id,
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      if (mapList.isNotEmpty) {
        var sc = StatusComanda.fromMap(mapList[0]);
        return sc;
      }
    }
    return null;
  }
}

void main() async {
  var f = StatusComandaDaoLocalHttp();
  var lista = await f.listarTodos();
  lista.map((e) => print(e));
}

