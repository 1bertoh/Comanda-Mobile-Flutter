import 'package:projeto_tutorial/dao/dao.dart';
import 'package:projeto_tutorial/model/comercio.dart';

class FuncionarioDaoMemory implements Dao<Funcionario> {
  List<Funcionario> listaFuncionario = [
    Funcionario(
      codigo: 1,
      nome: 'Asdrubal de Souza',
      cpf: 12345678900,
      endereco: 'Rua Fulano, 1',
      telefone: '28999190019',
      email: 'asdrubal@asdrubalco.com',
      cargo: 'CEO',
    ),
    Funcionario(
      codigo: 2,
      nome: 'Melquisedeque Abreu',
      cpf: 12345678912,
      endereco: 'Rua Beltrano, 2',
      telefone: '28999918277',
      email: 'melquisa@enois.com',
      cargo: 'Faxineiro',
    ),
    Funcionario(
      codigo: 3,
      nome: 'Gertrudes Almeida Prado',
      cpf: 98765432100,
      endereco: 'Rua das Acácias, 98',
      telefone: '28991898765',
      email: 'almeidinha@gmai1.com',
      cargo: 'Operadora de Pare-Siga',
    ),
  ];

  @override
  Future<bool> alterar(Funcionario item) async {
    for (int i = 0; i < listaFuncionario.length; i++) {
      if (listaFuncionario[i].codigo == item.codigo) {
        listaFuncionario[i] = item;
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> excluir(Funcionario item) async {
    for (int i = 0; i < listaFuncionario.length; i++) {
      if (listaFuncionario[i].codigo == item.codigo) {
        listaFuncionario.removeAt(i);
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> inserir(Funcionario item) async {
    listaFuncionario.add(item);
    return true;
  }

  @override
  Future<List<Funcionario>> listarTodos() async {
    return listaFuncionario;
  }

  @override
  Future<Funcionario?> selecionarPorId(int id) async {
    for (int i = 0; i < listaFuncionario.length; i++) {
      if (listaFuncionario[i].id == id) {
        return listaFuncionario[i];
      }
    }
    return null;
  }
}
