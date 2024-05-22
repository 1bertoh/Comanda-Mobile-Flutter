import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:projeto_tutorial/dao/dao.dart';
import 'dart:io' show Platform;

import 'package:projeto_tutorial/model/tipoComida.dart';

class TipoComidaDaoLocalHttp implements Dao<TipoComida> {

  static String hostServidor = (!kIsWeb && Platform.isAndroid) ? 'servidor-comanda-mobile.humbertojunior3.repl.co' : 'localhost';
  static const portaServidor = 443;
  static const nomeEntidadeSing = 'tipocomida';
  static const nomeEntidadeplur = 'tiposcomida';

  @override
  Future<bool> alterar(TipoComida item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidadeSing, {
      'codigo': item.id,
      'nome': item.nome
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
  Future<bool> excluir(TipoComida item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidadeSing, {
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
  Future<bool> inserir(TipoComida item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidadeSing, {
      'codigo': item.id,
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
  Future<List<TipoComida>> listarTodos() async {
    List<TipoComida> lista = [];
    var url = Uri.https('$hostServidor:$portaServidor', nomeEntidadeplur);
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes));
      for (var map in mapList) {
        var tc = TipoComida.fromMap(map);
        lista.add(tc);
      }
    } else {
      print('Erro no status code: ${response.statusCode}');
    }
    return lista;
  }

  @override
  Future<TipoComida?> selecionarPorId(int id) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidadeSing, {
      'id': id,
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      if (mapList.isNotEmpty) {
        var tc = TipoComida.fromMap(mapList[0]);
        return tc;
      }
    }
    return null;
  }
}

void main() async {
  var f = TipoComidaDaoLocalHttp();
  var lista = await f.listarTodos();
  lista.map((e) => print(e));
}

