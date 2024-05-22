import 'package:projeto_tutorial/dao/dao_entity.dart';

abstract class Cliente {
  int codigo;
  String endereco;
  String telefone;
  String email;

  Cliente({
    required this.codigo,
    required this.endereco,
    required this.telefone,
    required this.email,
  });
}

class ClientePessoaFisica extends Cliente {
  int cpf;
  String sexo;
  String nome;
  DateTime dataNascimento;

  ClientePessoaFisica({
    required super.codigo,
    required super.endereco,
    required super.telefone,
    required super.email,
    required this.cpf,
    required this.sexo,
    required this.nome,
    required this.dataNascimento,
  });
}

class CarroPasseio implements DaoEntity {
  int codigo;
  String marca;
  String modelo;
  double capacidadeMotor;
  String combustivel;
  int maxPessoas;
  double capacidadePortaMalas;
  String observacoes;

  CarroPasseio({
    required this.codigo,
    required this.marca,
    required this.modelo,
    required this.capacidadeMotor,
    required this.combustivel,
    required this.maxPessoas,
    required this.capacidadePortaMalas,
    required this.observacoes,
  });

  CarroPasseio.empty() : this(
    codigo: 0,
    marca: '',
    modelo: '',
    capacidadeMotor: 0,
    combustivel: '',
    maxPessoas: 0,
    capacidadePortaMalas: 0,
    observacoes: '',
  );

  @override
  void fromMap(Map<String, Object?> map) {
    codigo = map['codigo'] as int;
    marca = map['marca'] as String;
    modelo = map['modelo'] as String;
    capacidadeMotor = map['capacidadeMotor'] as double;
    combustivel = map['combustivel'] as String;
    maxPessoas = map['maxPessoas'] as int;
    capacidadePortaMalas = map['capacidadePortaMalas'] as double;
    observacoes = map['observacoes'] as String;
  }

  @override
  int get id => codigo;

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{};
    map['codigo'] = codigo;
    map['marca'] = marca;
    map['modelo'] = modelo;
    map['capacidadeMotor'] = capacidadeMotor;
    map['combustivel'] = combustivel;
    map['maxPessoas'] = maxPessoas;
    map['capacidadePortaMalas'] = capacidadePortaMalas;
    map['observacoes'] = observacoes;
    return map;
  }

}

class Funcionario implements DaoEntity {
  int codigo;
  String nome;
  int cpf;
  String endereco;
  String telefone;
  String email;
  String cargo;

  Funcionario({
    required this.codigo,
    required this.nome,
    required this.cpf,
    required this.endereco,
    required this.telefone,
    required this.email,
    required this.cargo,
  });

  Funcionario.empty() : this(
    codigo: DaoEntity.idInvalido,
    nome: '',
    cpf: 0,
    endereco: '',
    telefone: '',
    email: '',
    cargo: '',
  );

  Funcionario.fromMap(Map<String, Object?> map) : this(
    codigo: map['codigo'] as int,
    nome: map['nome'] as String,
    cpf: map['cpf'] as int,
    endereco: map['endereco'] as String,
    telefone: map['telefone'] as String,
    email: map['email'] as String,
    cargo: map['cargo'] as String,
  );

  @override
  void fromMap(Map<String, Object?> map) {
    codigo = map['codigo'] as int;
    nome = map['nome'] as String;
    cpf = map['cpf'] as int;
    endereco = map['endereco'] as String;
    telefone = map['telefone'] as String;
    email = map['email'] as String;
    cargo = map['cargo'] as String;
  }

  @override
  int get id => codigo;

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'codigo': codigo,
      'nome': nome,
      'cpf': cpf,
      'endereco': endereco,
      'telefone': telefone,
      'email': email,
      'cargo': cargo,
    };
    return map;
  }
}

class Venda {
  int codigo;
  DateTime dataVenda;
  double valorTotal;
  Funcionario vendedor;
  Cliente cliente;

  Venda({
    required this.codigo,
    required this.dataVenda,
    required this.valorTotal,
    required this.vendedor,
    required this.cliente,
  });
}
