import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:projeto_tutorial/dao/dao.dart';
import 'dart:io' show Platform;

import 'package:projeto_tutorial/model/comida.dart';

class ComidaDaoLocalHttp implements Dao<Comida> {

  static String hostServidor = (!kIsWeb && Platform.isAndroid) ? 'servidor-comanda-mobile.humbertojunior3.repl.co' : 'localhost';
  static const portaServidor = 443;
  static const nomeEntidadeSing = 'comida';
  static const nomeEntidadePlur = 'comidas';

  @override
  Future<bool> alterar(Comida item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidadeSing, {
      'codigo': item.id,
      'nome': item.nome,
      'descricao': item.descricao,
      'preco': item.preco,
      'status': item.status,
      'imagem': item.imagem,
      'desconto': item.desconto,
      'id_tipo': item.tipo
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
  Future<bool> excluir(Comida item) async {
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
  Future<bool> inserir(Comida item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidadeSing, {
      'codigo': item.id,
      'nome': item.nome,
      'descricao': item.descricao,
      'preco': item.preco,
      'status': item.status,
      'imagem': item.imagem,
      'desconto': item.desconto,
      'id_tipo': item.tipo
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
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
  Future<List<Comida>> listarTodos() async {
    List<Comida> lista = [];
    var url = Uri.https('$hostServidor:$portaServidor', nomeEntidadePlur);
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes));
      for (var map in mapList) {
        var comida = Comida.fromMap(map);
        lista.add(comida);
      }
    } else {
      print('Erro no status code: ${response.statusCode}');
    }
    return lista;
  }

  @override
  Future<Comida?> selecionarPorId(int id) async {
    var url = Uri.https('$hostServidor:$portaServidor', nomeEntidadeSing, {
      'id': id,
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      if (mapList.isNotEmpty) {
        var comida = Comida.fromMap(mapList[0]);
        return comida;
      }
    }
    return null;
  }
}

void main() async {
  var f = ComidaDaoLocalHttp();
  var lista = await f.listarTodos();
  lista.map((e) => print(e));
}

