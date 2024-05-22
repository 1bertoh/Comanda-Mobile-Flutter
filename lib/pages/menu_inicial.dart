import 'package:flutter/material.dart';
import 'package:projeto_tutorial/pages/listagem_mesas.dart';

class MenuInicial extends StatelessWidget {
  const MenuInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comanda Mobile')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => abrirListagemFuncionario(context),
              child: const Text('Mesas'),
            ),
          ],
        ),
      ),
    );
  }

  void abrirListagemFuncionario(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ListagemMesas()));
  }
}
