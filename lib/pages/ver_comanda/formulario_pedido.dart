import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/dao/dao_entity.dart';
import 'package:projeto_tutorial/dao/database_helper.dart';
import 'package:projeto_tutorial/main.dart';
import 'package:projeto_tutorial/model/comida.dart';
import 'package:projeto_tutorial/model/pedido.dart';

class FormularioPedido extends StatefulWidget {
  //Se vier um pedido é porque eu quero editar um pedido, se não vier é porquer quero criar um novo
  final List<Comida>? comidas;
  final Pedido? pedido;
  final int idComanda;
  const FormularioPedido({super.key, required this.comidas, required this.pedido, required this.idComanda });

  @override
  State<FormularioPedido> createState() => _FormularioPedidoState();
}

class _FormularioPedidoState extends State<FormularioPedido> {
  late Pedido _pedido;
  late List<Comida> _comidas;
  final _formKey = GlobalKey<FormBuilderState>();
   late Dao<Pedido> pedidoDao;
   late Dao<Comida> comidaDao;
    String dropdownStatusValue = 'PENDENTE';
    int dropdownComidaValue = 1;

  @override
  void initState() {
    super.initState();
    _pedido = Pedido.empty();
    _comidas = [Comida.empty()];
    pedidoDao = DatabaseHelper.instance.pedidoDao;
    comidaDao = DatabaseHelper.instance.comidaDao;
    carregarFuncionarios();
  }

  void carregarFuncionarios() async {
    // PedidoDaoLocalHttp pedidoDao = PedidoDaoLocalHttp();
    if(widget.pedido != null){
      // var pedido = await pedidoDao.selecionarPorId(widget.pedido!.codigo);
      setState(() {
        _pedido = widget.pedido!;
      });
    }
    if(widget.comidas == null){
      var comidas = await comidaDao.listarTodos();
      setState(() {
        _comidas = comidas;
      });
    } else {
      setState(() {
        _comidas = widget.comidas!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dadosRegistro = <String, Object>{
      'id_comanda': (widget.idComanda).toString(),
      'id_comida': (_pedido.idComida).toString(),
      'status': (_pedido.status),
      'observacao': (_pedido.observacao).toString(),
      'create_at': DateTime.now().toString()
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Criar pedido')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: dadosRegistro,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              FormBuilderTextField(
                name: 'id_comanda',
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: const InputDecoration(
                  label: Text('comanda id'),
                  hintText: 'Id da comanda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
            DropdownButton(
              value: dropdownComidaValue,
              items: _comidas.map((e) {
                return DropdownMenuItem(value: e.id, child: Text("${e.nome} R\$ ${e.preco}"),);
              }).toList(),
              onChanged: (int? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownComidaValue = value!;
                });
              },
            ),
              const SizedBox(height: 8.0),
              DropdownButton(
                  value: dropdownStatusValue,
                  items: const [
                    DropdownMenuItem(value: 'PENDENTE', child: Text("Pendente"),),
                    DropdownMenuItem(value: 'EM PROCESSO', child: Text("Em processo")),
                    DropdownMenuItem(value: 'CONCLUIDO', child: Text("Concluído"),),
                    DropdownMenuItem(value: 'CANCELADO', child: Text("Cancelado"),)
                  ],
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                    dropdownStatusValue = value!;
                  });
                },
              ),
              const SizedBox(height: 8.0),
              FormBuilderTextField(
                name: 'create_at',
                readOnly: true,
                decoration: const InputDecoration(
                  label: Text('Data de Criação'),
                  hintText: 'Data de criação',
                  border: OutlineInputBorder(),
                ),
              ),const SizedBox(height: 8.0),
              FormBuilderTextField(
                name: 'observacao',
                decoration: const InputDecoration(
                  label: Text('observação'),
                  hintText: 'Observação',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: salvarRegistro,
                    child: const Text('Salvar'),
                  ),
                  const SizedBox(width: 8.0),
                  (_pedido.id != DaoEntity.idInvalido
                      ? ElevatedButton(
                    onPressed: excluirRegistro,
                    child: const Text('Excluir'),
                  )
                      : Container()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  void obtemDadosDoFormulario() {
    if (_formKey.currentState != null) {
      _pedido.idComanda = int.parse(_formKey.currentState!.fields['id_comanda']!.value);
      _pedido.idComida = dropdownComidaValue;
      _pedido.createAt = _formKey.currentState!.fields['create_at']!.value.toString();
      _pedido.status = dropdownStatusValue;
      _pedido.observacao = _formKey.currentState!.fields['observacao']!.value.toString();
    }
  }

  void executarPop({required bool resultado}) {
    Navigator.pop(context, resultado);
  }

  void salvarRegistro() async {
    if (_formKey.currentState != null) {
      obtemDadosDoFormulario();
      if (_pedido.id == DaoEntity.idInvalido) {
        if (await pedidoDao.inserir(_pedido)) {
          var snackBar = const SnackBar(
            content: Text('Registro do pedido foi inserido.'),
          );
          if (AppTutorial.scaffoldKey.currentState != null) {
            AppTutorial.scaffoldKey.currentState!.showSnackBar(snackBar);
          }
          executarPop(resultado: true);
          executarPop(resultado: true);
        }
      } else {
        if (await pedidoDao.alterar(_pedido)) {
          var snackBar = const SnackBar(
            content: Text('Registro de comanda foi alterado.'),
          );
          if (AppTutorial.scaffoldKey.currentState != null) {
            AppTutorial.scaffoldKey.currentState!.showSnackBar(snackBar);
          }
          executarPop(resultado: true);
        }
      }
    }
  }

  void excluirRegistro() async {
    var resposta = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir'),
          content: const Text('Excluir comandao selecionado?'),
          actions: [
            TextButton(
              onPressed: () async {
                var result = await pedidoDao.excluir(_pedido);
                if (!context.mounted) return;
                executarPop(resultado: result);
              },
              child: const Text('Excluir'),
            ),
            TextButton(
              onPressed: () {
                if (!context.mounted) return;
                executarPop(resultado: false);
              },
              child: const Text('Voltar'),
            ),
          ],
        );
      },
    );
    if (resposta is bool && resposta) {
      executarPop(resultado: resposta);
    }
  }
}

