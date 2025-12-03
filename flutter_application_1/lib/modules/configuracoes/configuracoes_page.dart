import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart'; // Importe o controller

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: ListView(
        children: [
          // Card de Tema
          Card(
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text("Tema do Aplicativo"),
              subtitle: Text(isDark ? "Modo Escuro Ativado" : "Modo Claro Ativado"),
              trailing: Switch(
                value: isDark,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
                  // AQUI A MÁGICA ACONTECE
                  ThemeController.instance.toggleTheme();
                },
              ),
            ),
          ),
          
          // Outras configurações...
        ],
      ),
    );
  }
}