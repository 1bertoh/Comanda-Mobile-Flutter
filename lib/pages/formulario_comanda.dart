import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/dao/dao_entity.dart';
import 'package:projeto_tutorial/dao/database_helper.dart';
import 'package:projeto_tutorial/dao/local_http/comanda_dao_local_http.dart';
import 'package:projeto_tutorial/main.dart';
import 'package:projeto_tutorial/model/comanda.dart';
import 'package:projeto_tutorial/model/mesa.dart';
import 'package:projeto_tutorial/model/statusComanda.dart';

class FormularioComanda extends StatefulWidget {
  final Mesa? mesa;
  const FormularioComanda({super.key, required this.mesa});

  @override
  State<FormularioComanda> createState() => _FormularioComandaState();
}

class _FormularioComandaState extends State<FormularioComanda> {
  late Comanda _comanda;
  late List<StatusComanda> _statusComanda;
  final _formKey = GlobalKey<FormBuilderState>();
  late Dao<Comanda> comandaDao;
  late Dao<StatusComanda> statusComandaDao;
  int statusComandaValue = 1;


  @override
  void initState() {
    super.initState();
    _comanda = Comanda.empty();
    _statusComanda = [StatusComanda.empty()];
    comandaDao = DatabaseHelper.instance.comandaDao;
    statusComandaDao = DatabaseHelper.instance.statusComandaDao;
    carregarFuncionarios();
  }

  void carregarFuncionarios() async {
    ComandaDaoLocalHttp comandaDaoHttp = ComandaDaoLocalHttp();
    var comanda = await comandaDaoHttp.selecionarPorMesa(widget.mesa!.codigo);
    var statusComanda = await statusComandaDao.listarTodos();
    setState(() {
      _comanda = comanda ?? Comanda.empty();
      _statusComanda = statusComanda ;
    });
  }

  @override
  Widget build(BuildContext context) {
    var dadosRegistro = <String, Object>{
      'id_mesa': (widget.mesa!.codigo).toString(),
      'id_status': (_comanda.idStatus).toString(),
      'create_at': DateTime.now().toString(),
      'valor': (_comanda.valor).toString(),
      'desconto': (_comanda.desconto).toString(),
      'observacao': _comanda.observacao,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Comanda')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: dadosRegistro,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              FormBuilderTextField(
                name: 'id_mesa',
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('id da mesa'),
                  hintText: 'Número da mesa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              teste(),
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
                name: 'valor',
                readOnly: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  label: Text('Valor'),
                  hintText: 'Valor da comanda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              FormBuilderTextField(
                name: 'desconto',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  label: Text('Desconto'),
                  hintText: 'desconto na comanda',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
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
                  (_comanda.id != DaoEntity.idInvalido
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

  Widget teste() {
    try{
      return DropdownButton(
          value: statusComandaValue,
          items: _statusComanda.map((e)  {
            return DropdownMenuItem(value: e.codigo, child: Text(e.status));
          }).toList(),
          onChanged: (int? id) {
            setState(() {
              statusComandaValue = id!;
            });
          }
      );
    }catch(e){
      return DropdownButton(
          value: 0,
          items: const [
            DropdownMenuItem(value: 0, child: Text("Carregando..."),)
          ],
          onChanged: (int)=>{}
      );
    }

  }

  void obtemDadosDoFormulario() {
    if (_formKey.currentState != null) {
      _comanda.idMesa = int.parse(_formKey.currentState!.fields['id_mesa']!.value);
      _comanda.idStatus = statusComandaValue;
      _comanda.createdAt = _formKey.currentState!.fields['create_at']!.value.toString();
      _comanda.valor = double.parse(_formKey.currentState!.fields['valor']!.value);
      _comanda.desconto = double.parse(_formKey.currentState!.fields['desconto']!.value);
      _comanda.observacao = _formKey.currentState!.fields['observacao']!.value.toString();
    }
  }

  void executarPop({required bool resultado}) {
    Navigator.pop(context, resultado);
  }

  void salvarRegistro() async {
    if (_formKey.currentState != null) {
      obtemDadosDoFormulario();
      if (_comanda.id == DaoEntity.idInvalido) {
        if (await comandaDao.inserir(_comanda)) {
          var snackBar = const SnackBar(
            content: Text('Registro da comanda foi inserido.'),
          );
          if (AppTutorial.scaffoldKey.currentState != null) {
            AppTutorial.scaffoldKey.currentState!.showSnackBar(snackBar);
          }
          executarPop(resultado: true);
        }
      } else {
        if (await comandaDao.alterar(_comanda)) {
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
    // executarPop(resultado: true);
  }

  void gotBack() {
    Navigator.of(context).pop();

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
                var result = await comandaDao.excluir(_comanda);
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

