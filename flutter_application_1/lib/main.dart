import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart'; 

import 'modules/home/home_page.dart';
import 'modules/transacoes/transacoes_page.dart';
import 'modules/transacoes/transacao_form_page.dart';
import 'modules/estatisticas/estatisticas_page.dart';
import 'modules/configuracoes/configuracoes_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.setSystemStyle();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Envolvemos o MaterialApp com o ouvinte do ThemeController
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Controle Financeiro',
          
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          
          // O modo agora é dinâmico!
          themeMode: currentMode, 

          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/transacoes': (context) => const TransacoesPage(),
            '/transacao_form': (context) => const TransacaoFormPage(),
            '/estatisticas': (context) => const EstatisticasPage(),
            '/configuracoes': (context) => const ConfiguracoesPage(),
          },
        );
      },
    );
  }
}