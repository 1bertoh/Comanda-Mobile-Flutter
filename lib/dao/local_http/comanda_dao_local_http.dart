import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/model/comanda.dart';
import 'dart:io' show Platform;

class ComandaDaoLocalHttp implements Dao<Comanda> {

  static String hostServidor = (!kIsWeb && Platform.isAndroid) ? 'servidor-comanda-mobile.humbertojunior3.repl.co' : 'localhost';
  static const portaServidor = 443;
  static const nomeEntidadeSing = 'comanda';
  static const nomeEntidadeplur = 'comandas';

  @override
  Future<bool> alterar(Comanda item) async {
    String pathValues = '${item.id}/${item.idMesa}/${item.idStatus}/${item.createdAt}/${item.valor}/${item.desconto}';
    var url = Uri.http('$hostServidor:$portaServidor', "$nomeEntidadeSing/update/$pathValues}");
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
  Future<bool> excluir(Comanda item) async {
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
  Future<bool> inserir(Comanda item) async {
    String pathValues = 'id_mesa/${item.idMesa}/id_status/${item.idStatus}/create_at/${item.createdAt}/valor/${item.valor}/desconto/${item.desconto}/observacao/${item.observacao}';
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
  Future<List<Comanda>> listarTodos() async {
    List<Comanda> lista = [];
    var url = Uri.https('$hostServidor:$portaServidor', nomeEntidadeplur, {
      'inicio': '1970-01-01',
      'fim': '2050-01-01'
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes));
      for (var map in mapList) {
        var comanda = Comanda.fromMap(map);
        lista.add(comanda);
      }
    } else {
      print('Erro no status code: ${response.statusCode}');
    }
    return lista;
  }

  @override
  Future<Comanda?> selecionarPorId(int id) async {
    var url = Uri.http('$hostServidor:$portaServidor', nomeEntidadeSing, {
      'id': id,
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      if (mapList.isNotEmpty) {
        var comanda = Comanda.fromMap(mapList[0]);
        return comanda;
      }
    }
    return null;
  }

  Future<Comanda?> selecionarPorMesa(int idMesa) async {
    var url = Uri.https('$hostServidor:$portaServidor', '$nomeEntidadeSing/mesa/$idMesa');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = [jsonDecode(utf8.decode(response.bodyBytes))];
      if (mapList.isNotEmpty) {
        var comanda = Comanda.fromMap(mapList[0]);
        return comanda;
      }
    }
    return null;
  }
}

void main() async {
  var f = ComandaDaoLocalHttp();
  var lista = await f.listarTodos();
  lista.map((e) => print(e));
}

