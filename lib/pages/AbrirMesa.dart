import 'package:flutter/material.dart';
import 'package:projeto_tutorial/model/mesa.dart';
import 'package:projeto_tutorial/pages/formulario_comanda.dart';
import 'package:projeto_tutorial/pages/ver_comanda/ver_comanda.dart';

class AbrirMesa extends StatefulWidget {
  final Mesa? mesa;
  const AbrirMesa({super.key, required this.mesa});

  @override
  State<AbrirMesa> createState() => _AbrirMesaState();
}

class _AbrirMesaState extends State<AbrirMesa> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Mesa ${widget.mesa?.id}"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () => abrirFormularioComanda(widget.mesa), child: const Text("Criar comanda")),
            ElevatedButton(onPressed: () => abrirVerComanda(widget.mesa), child: const Text("Ver comanda")),
            const ElevatedButton(onPressed: null, child: Text("Fazer pedido")),
            const ElevatedButton(onPressed: null, child: Text("Ver pedido")),
            const ElevatedButton(onPressed: null, child: Text("Ver cardápio")),
          ],
        ),
      ),
    );
  }

  abrirFormularioComanda(Mesa? mesa) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioComanda(mesa: mesa),
      ),
    );
    if (result is bool && result) {
      // carregarFuncionarios();
    }
  }

  abrirVerComanda(Mesa? mesa) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerComanda(mesa: mesa),
      ),
    );
    if (result is bool && result) {
      // carregarFuncionarios();
    }
  }
}

