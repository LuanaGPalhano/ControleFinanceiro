import 'package:flutter/material.dart';

class EstatisticasPage extends StatelessWidget {
  const EstatisticasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Estatísticas")),
      body: const Center(
        child: Text("Gráficos e análises"),
      ),
    );
  }
}
