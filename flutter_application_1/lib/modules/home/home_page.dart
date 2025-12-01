import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Controle Financeiro")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/transacoes');
              },
              child: const Text("Transações"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/estatisticas');
              },
              child: const Text("Estatísticas"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/configuracoes');
              },
              child: const Text("Configurações"),
            ),
          ],
        ),
      ),
    );
  }
}
