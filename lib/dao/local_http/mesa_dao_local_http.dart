import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:projeto_tutorial/dao/dao.dart';
import 'dart:io' show Platform;

import 'package:projeto_tutorial/model/mesa.dart';

class MesaDaoLocalHttp implements Dao<Mesa> {

  static String hostServidor = (!kIsWeb && Platform.isAndroid) ? 'servidor-comanda-mobile.humbertojunior3.repl.co' : 'localhost';
  static const portaServidor = 443;
  static const nomeEntidade = 'mesa/';

  @override
  Future<bool> alterar(Mesa item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidade, {
      'codigo': item.codigo,
      'nome': item.nome,
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
  Future<bool> excluir(Mesa item) async {
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
  Future<bool> inserir(Mesa item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidade, {
      'nome': item.nome,
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
  Future<List<Mesa>> listarTodos() async {
    List<Mesa> lista = [];
    var url = Uri.https('$hostServidor:$portaServidor', nomeEntidade, {
      'nome': 'mesa'
    }.map((key, value) => MapEntry(key, value.toString())));
    print(url.toString());
    var response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes));
      for (var map in mapList) {
        print(map);
        var mesa = Mesa.fromMap(map);
        lista.add(mesa);

      }
    } else {
      print('Erro no status code: ${response.statusCode}');
    }
    print(lista);
    return lista;
  }

  Future<List<Mesa>> listarPorNome({required String nome}) async {
    List<Mesa> lista = [];
    var url = Uri.https('$hostServidor:$portaServidor', nomeEntidade, {
      'nome': nome
    }.map((key, value) => MapEntry(key, value.toString())));
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes));
      for (var map in mapList) {
        var mesa = Mesa.fromMap(map);
        lista.add(mesa);
      }
    } else {
      print('Erro no status code: ${response.statusCode}');
    }
    return lista;
  }

  @override
  Future<Mesa?> selecionarPorId(int id) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidade, {
      'id': id,
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      if (mapList.isNotEmpty) {
        var mesa = Mesa.fromMap(mapList[0]);
        return mesa;
      }
    }
    return null;
  }
}

void main() async {
  var f = MesaDaoLocalHttp();
  var lista = await f.listarTodos();
  lista.map((e) => print(e));
}

