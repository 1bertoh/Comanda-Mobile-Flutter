import 'package:flutter/material.dart';
import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/dao/database_helper.dart';
import 'package:projeto_tutorial/dao/local_http/comanda_dao_local_http.dart';
import 'package:projeto_tutorial/dao/local_http/pedido_dao_local_http.dart';
import 'package:projeto_tutorial/model/comanda.dart';
import 'package:projeto_tutorial/model/comida.dart';
import 'package:projeto_tutorial/model/mesa.dart';
import 'package:projeto_tutorial/model/pedido.dart';
import 'package:projeto_tutorial/model/statusComanda.dart';
import 'package:projeto_tutorial/pages/ver_comanda/formulario_pedido.dart';
import 'package:projeto_tutorial/utils/utils.dart';

class VerComanda extends StatefulWidget {
  final Mesa? mesa;
  const VerComanda({super.key, required this.mesa});

  @override
  State<VerComanda> createState() => _VerComandaState();
}

class _VerComandaState extends State<VerComanda> {
  late Comanda _comanda;
  late ComandaDaoLocalHttp comandaDao;
  late List<StatusComanda> _status;
  late Dao<StatusComanda> statusDao;
  late List<Pedido> _pedidos;
  late PedidoDaoLocalHttp pedidoDao;
  late List<Comida> _comidas;
  late Dao<Comida> comidaDao;

  @override
  void initState() {
    super.initState();
    _comanda = Comanda.empty();
    _status = [StatusComanda.empty()];
    _pedidos = [Pedido.empty()];
    _comidas = [Comida.empty()];
    comandaDao = ComandaDaoLocalHttp();
    statusDao = DatabaseHelper.instance.statusComandaDao;
    pedidoDao = PedidoDaoLocalHttp();
    comidaDao = DatabaseHelper.instance.comidaDao;
    carregarFuncionarios();
  }

  void carregarFuncionarios() async {
    var comanda = await comandaDao.selecionarPorMesa(widget.mesa!.codigo);
    var status = await statusDao.listarTodos();
    var pedidos = await pedidoDao.selecionarPorIdComanda(comanda!.id);
    var comidas = await comidaDao.listarTodos();

    setState(() {
      _comanda = comanda;
      _status = status;
      _pedidos = pedidos;
      _comidas = comidas;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendo Comanda')),
      body: _comanda.id != -1 ? mesaTemComanda() : Center(child: Text('Cadastre uma comanda para esta mesa.', style: Theme.of(context).textTheme.titleMedium,)),
      floatingActionButton: FloatingActionButton(onPressed: _comanda.id != -1 ? abrirPedidoFormulario : null, mini: true, child: const Icon(Icons.note_alt_outlined)),
    );
  }

  Widget mesaTemComanda(){
    String situacao = _status.map((e) => e.codigo == _comanda.idStatus ? e.status : 'Livre').toList()[0];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.mesa!.nome, style: Theme.of(context).textTheme.displaySmall,),
                  Text(situacao)
                ],
              ),
              Text(Utils.formattedDateTime(_comanda.createdAt), textAlign: TextAlign.left, style: Theme.of(context).textTheme.labelSmall,),
              const Divider(),
              criarPedidosTable()
            ],
          )
        ],
      ),
    );
  }
  
  Widget criarPedidosTable(){
    List<dynamic> comidas = [];

    if(_comidas.isNotEmpty){
        _pedidos.forEach((element) {
          int idComida = element.idComida;
          Comida comida = _comidas.firstWhere((c) => c.id == idComida, orElse: () => Comida.empty());
          comidas.add({
            "comida": comida,
            "pedido": element
          });
        });
    }

    return DataTable(
        dataRowMaxHeight: 100,
        columns: const [
          DataColumn(label: Text("Pedido")),
          DataColumn(label: Text("Preço")),
          DataColumn(label: Text("Status")),
        ],
        rows: comidas.map((element) {
          return DataRow(
              cells: [
                DataCell(Text(element["comida"]?.nome)),
                DataCell(Text("R\$ ${element["comida"]?.preco}")),
                DataCell(Text(element["pedido"]?.status))
              ]
          );
        }).toList()
    );
  }

  void abrirPedidoFormulario() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioPedido(comidas: _comidas, idComanda: _comanda.id, pedido: null, ),
      ),
    );
    if (result is bool && result) {
      // carregarFuncionarios();
    }
  }
}

