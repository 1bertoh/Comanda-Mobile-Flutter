import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/model/comanda.dart';
import 'dart:io' show Platform;

import 'package:projeto_tutorial/model/pedido.dart';

class PedidoDaoLocalHttp implements Dao<Pedido> {

  static String hostServidor = (!kIsWeb && Platform.isAndroid) ? 'servidor-comanda-mobile.humbertojunior3.repl.co' : 'localhost';
  static const portaServidor = 443;
  static const nomeEntidadeSing = 'pedido';
  static const nomeEntidadeplur = 'pedidos';

  @override
  Future<bool> alterar(Pedido item) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidadeSing, {
      'codigo': item.id,
      'id_comanda': item.idComanda,
      'id_comida': item.idComida,
      'status': item.status,
      'observacao': item.observacao,
      'create_at': item.createAt,
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
  Future<bool> excluir(Pedido item) async {
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
  Future<bool> inserir(Pedido item) async {
    String pathValues = 'id_comanda/${item.idComanda}/id_comida/${item.idComida}/status/${item.status}/observacao/${item.observacao}/create_at/${item.createAt}';
    var url = Uri.https('$hostServidor:$portaServidor', '$nomeEntidadeSing/create/$pathValues');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = [jsonDecode(utf8.decode(response.bodyBytes))];
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
  Future<List<Pedido>> listarTodos() async {
    List<Pedido> lista = [];
    var url = Uri.https('$hostServidor:$portaServidor', nomeEntidadeplur, {
      'inicio': '1970-01-01',
      'fim': '2050-01-01'
    }.map((key, value) => MapEntry(key, value.toString())));
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes));
      for (var map in mapList) {
        var pedido = Pedido.fromMap(map);
        lista.add(pedido);
      }
    } else {
      print('Erro no status code: ${response.statusCode}');
    }
    return lista;
  }

  @override
  Future<Pedido?> selecionarPorId(int id) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidadeSing, {
      'id': id,
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      if (mapList.isNotEmpty) {
        var pedido = Pedido.fromMap(mapList[0]);
        return pedido;
      }
    }
    return null;
  }

  Future<List<Pedido>> selecionarPorIdComanda(int idComanda) async {
    List<Pedido>  lista = [];
    var url = Uri.https('$hostServidor:$portaServidor', '$nomeEntidadeplur/comanda/$idComanda');
    var response = await http.get(url);
    print(url);
    print(jsonDecode(utf8.decode(response.bodyBytes)));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes));
      for(var map in mapList){
        var pedido = Pedido.fromMap(map);
        lista.add(pedido);
      }
    } else {
      print('Erro no status code: ${response.statusCode}');
    }
    return lista;
  }
}

void main() async {
  var f = PedidoDaoLocalHttp();
  var lista = await f.listarTodos();
  lista.map((e) => print(e));
}

