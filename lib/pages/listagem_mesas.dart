import 'package:flutter/material.dart';
import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/dao/database_helper.dart';
import 'package:projeto_tutorial/model/mesa.dart';
import 'package:projeto_tutorial/pages/AbrirMesa.dart';

class ListagemMesas extends StatefulWidget {
  const ListagemMesas({super.key});

  @override
  State<ListagemMesas> createState() => _ListagemFuncionarioState();
}

class _ListagemFuncionarioState extends State<ListagemMesas> {
  late Dao<Mesa> mesaDao;
  late List<Mesa> listaMesas = [];

  @override
  void initState() {
    super.initState();
    mesaDao = DatabaseHelper.instance.mesaDao;
    carregarFuncionarios();
  }

  void carregarFuncionarios() async {
    var lista = await mesaDao.listarTodos();
    listaMesas.clear();
    setState(() {
      listaMesas.addAll(lista);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mesas')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Center(
              child: criarTabela()
            ),

          ],
        ),
      ),
    );
  }

  Widget criarTabela() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Id')),
          DataColumn(label: Text("Nome")),
        ],
        rows: listaMesas
            .map(
              (mesa) => DataRow(
                cells: [
                  DataCell(Text(mesa.codigo.toString())),
                  DataCell(Text(mesa.nome)),
                ],
                onLongPress: () =>  redirecionarAbrirMesa(mesa),

              ),
            )
            .toList(),
      ),
    );
  }

  void redirecionarAbrirMesa(Mesa? mesa) async{
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AbrirMesa(mesa: mesa),
      ),
    );
    if (result is bool && result) {
      carregarFuncionarios();
    }

  }

  void abrirFormularioFuncionario(Mesa? funcionario) async {
    // var result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FormularioFuncionario(registro: funcionario),
    //   ),
    // );
    // if (result is bool && result) {
    //   carregarFuncionarios();
    // }
  }
}
