import 'package:flutter/material.dart';
import 'transacao_model.dart';

class TransacaoFormPage extends StatelessWidget {
  const TransacaoFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova transação")),
      body: const Center(
        child: Text("Formulário de transação"),
      ),
    );
  }
}
