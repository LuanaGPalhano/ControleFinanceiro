import 'package:flutter/material.dart';
import '../../core/theme/theme_controller.dart'; 

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta se é dark mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: colorScheme.primary,
              ),
              title: const Text("Modo Escuro"),
              subtitle: Text(isDark ? "Ativado" : "Desativado"),
              trailing: Switch(
                value: isDark,
                onChanged: (value) {
                  ThemeController.instance.toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}