import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/dao/dao_entity.dart';
import 'package:projeto_tutorial/dao/database_helper.dart';
import 'package:projeto_tutorial/main.dart';
import 'package:projeto_tutorial/model/comercio.dart';

class FormularioFuncionario extends StatefulWidget {
  const FormularioFuncionario({super.key, this.registro});

  final Funcionario? registro;

  @override
  State<FormularioFuncionario> createState() => _FormularioFuncionarioState();
}

class _FormularioFuncionarioState extends State<FormularioFuncionario> {
  late Funcionario _registro;
  final _formKey = GlobalKey<FormBuilderState>();
  late Dao<Funcionario> funcionarioDao;

  @override
  void initState() {
    super.initState();
    funcionarioDao = DatabaseHelper.instance.funcionarioDao;

    if (widget.registro != null) {
      setState(() {
        _registro = widget.registro!;
      });
    } else {
      setState(() {
        _registro = Funcionario.empty();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dadosRegistro = <String, Object>{
      'nome': _registro.nome,
      'cpf': _registro.cpf.toString(),
      'endereco': _registro.endereco,
      'telefone': _registro.telefone,
      'email': _registro.email,
      'cargo': _registro.cargo,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Funcionário')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: dadosRegistro,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              FormBuilderTextField(
                name: 'nome',
                decoration: const InputDecoration(
                  label: Text('Nome'),
                  hintText: 'Nome do funcionário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              FormBuilderTextField(
                name: 'cpf',
                decoration: const InputDecoration(
                  label: Text('CPF'),
                  hintText: 'Digite apenas os números',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              FormBuilderTextField(
                name: 'endereco',
                decoration: const InputDecoration(
                  label: Text('Endereço'),
                  hintText: 'Endereço do funcionário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              FormBuilderTextField(
                name: 'telefone',
                decoration: const InputDecoration(
                  label: Text('Telefone'),
                  hintText: 'Telefone do funcionário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(
                  label: Text('E-mail'),
                  hintText: 'Endereço de e-mail do funcionário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              FormBuilderTextField(
                name: 'cargo',
                decoration: const InputDecoration(
                  label: Text('Cargo'),
                  hintText: 'Cargo que o funcionário ocupa',
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
                  (_registro.id != DaoEntity.idInvalido
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
      _registro.nome = _formKey.currentState!.fields['nome']!.value.toString();
      _registro.cpf = int.tryParse(_formKey.currentState!.fields['cpf']!.value) ?? 0;
      _registro.endereco = _formKey.currentState!.fields['endereco']!.value.toString();
      _registro.telefone = _formKey.currentState!.fields['telefone']!.value.toString();
      _registro.email = _formKey.currentState!.fields['email']!.value.toString();
      _registro.cargo = _formKey.currentState!.fields['cargo']!.value.toString();
    }
  }

  void executarPop({required bool resultado}) {
    Navigator.pop(context, resultado);
  }

  void salvarRegistro() async {
    if (_formKey.currentState != null) {
      obtemDadosDoFormulario();
      if (_registro.id == DaoEntity.idInvalido) {
        if (await funcionarioDao.inserir(_registro)) {
          var snackBar = const SnackBar(
            content: Text('Registro de funcionário foi inserido.'),
          );
          if (AppTutorial.scaffoldKey.currentState != null) {
            AppTutorial.scaffoldKey.currentState!.showSnackBar(snackBar);
          }
          executarPop(resultado: true);
        }
      } else {
        if (await funcionarioDao.alterar(_registro)) {
          var snackBar = const SnackBar(
            content: Text('Registro de funcionário foi alterado.'),
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
          content: const Text('Excluir registro selecionado?'),
          actions: [
            TextButton(
              onPressed: () async {
                var result = await funcionarioDao.excluir(_registro);
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

