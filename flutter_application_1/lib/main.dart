import 'package:flutter/material.dart';
import 'modules/home/home_page.dart';
import 'modules/transacoes/transacoes_page.dart';
import 'modules/transacoes/transacao_form_page.dart';
import 'modules/estatisticas/estatisticas_page.dart';
import 'modules/configuracoes/configuracoes_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle Financeiro',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/transacoes': (context) => const TransacoesPage(),
        '/transacao_form': (context) => const TransacaoFormPage(),
        '/estatisticas': (context) => const EstatisticasPage(),
        '/configuracoes': (context) => const ConfiguracoesPage(),
      },
    );
  }
}
