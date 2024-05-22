import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/model/comercio.dart';
import 'dart:io' show Platform;

class FuncionarioDaoLocalHttp implements Dao<Funcionario> {
  static const nomeOperacaoCreate = 'create';
  static const nomeOperacaoRetrieveAll = 'retrieve_all';
  static const nomeOperacaoRetrieveById = 'retrieve_by_id';
  static const nomeOperacaoUpdate = 'update';
  static const nomeOperacaoDelete = 'delete';

  static String hostServidor = (!kIsWeb && Platform.isAndroid) ? 'servidor-comanda-mobile.humbertojunior3.repl.co' : 'localhost';
  static const portaServidor = 443;
  static const nomeEntidade = 'funcionario';

  @override
  Future<bool> alterar(Funcionario item) async {
    var url = Uri.http('$hostServidor:$portaServidor', '${nomeEntidade}_$nomeOperacaoUpdate', {
      'codigo': item.codigo,
      'nome': item.nome,
      'cpf': item.cpf,
      'endereco': item.endereco,
      'telefone': item.telefone,
      'email': item.email,
      'cargo': item.cargo,
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
  Future<bool> excluir(Funcionario item) async {
    var url = Uri.http('$hostServidor:$portaServidor', '${nomeEntidade}_$nomeOperacaoDelete', {
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
  Future<bool> inserir(Funcionario item) async {
    var url = Uri.http('$hostServidor:$portaServidor', '${nomeEntidade}_$nomeOperacaoCreate', {
      'nome': item.nome,
      'cpf': item.cpf,
      'endereco': item.endereco,
      'telefone': item.telefone,
      'email': item.email,
      'cargo': item.cargo,
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
  Future<List<Funcionario>> listarTodos() async {
    List<Funcionario> lista = [];
    var url = Uri.https('$hostServidor:$portaServidor', "/");
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes));
      for (var map in mapList) {
        var funcionario = Funcionario.fromMap(map);
        lista.add(funcionario);
      }
    } else {
      print('Erro no status code: ${response.statusCode}');
    }
    return lista;
  }

  @override
  Future<Funcionario?> selecionarPorId(int id) async {
    var url = Uri.http('$hostServidor:$portaServidor', '${nomeEntidade}_$nomeOperacaoRetrieveById', {
      'id': id,
    }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var mapList = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      if (mapList.isNotEmpty) {
        var funcionario = Funcionario.fromMap(mapList[0]);
        return funcionario;
      }
    }
    return null;
  }
}

void main() async {
  var f = FuncionarioDaoLocalHttp();
  var lista = await f.listarTodos();
  lista.map((e) => print(e));
}
