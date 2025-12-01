import 'package:flutter/material.dart';

class TransacoesPage extends StatelessWidget {
  const TransacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transações")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/transacao_form'),
          child: const Text("Adicionar transação"),
        ),
      ),
    );
  }
}
