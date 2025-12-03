import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessando as cores do tema definido
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Olá, Usuário",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
            Text(
              "Controle Financeiro",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.notifications_outlined),
            iconSize: 22, // Ícone menor
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20), // Padding da tela reduzido um pouco
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==========================================
            // 1. CARD DE SALDO
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20), // Padding interno reduzido
              decoration: BoxDecoration(
                color: colorScheme.primary, 
                borderRadius: BorderRadius.circular(16), // Borda um pouco mais fechada
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Saldo Total",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "R\$ 12.450,00", 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26, // Fonte menor (era 32)
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniInfo(
                        icon: Icons.arrow_downward,
                        label: "Receitas",
                        value: "R\$ 15k",
                        onColor: Colors.white,
                      ),
                      Container(width: 1, height: 30, color: Colors.white24),
                      _buildMiniInfo(
                        icon: Icons.arrow_upward,
                        label: "Despesas",
                        value: "R\$ 2.5k",
                        onColor: Colors.white,
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Ações Rápidas",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // ==========================================
            // 2. GRID DE BOTÕES (AGORA MAIS COMPACTO)
            // ==========================================
            GridView.count(
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, 
              crossAxisSpacing: 12, // Espaço menor entre botões
              mainAxisSpacing: 12,
              
              // --- AQUI ESTÁ O TRUQUE DO TAMANHO ---
              // Quanto maior o número, mais "achatado" o botão fica.
              // 1.5 era quadrado/retangular. 2.0 é bem retangular (baixo).
              childAspectRatio: 2.1, 
              
              children: [
                _buildActionCard(
                  context,
                  icon: Icons.swap_horiz,
                  label: "Transações",
                  route: "/transacoes",
                  colorScheme: colorScheme,
                ),
                _buildActionCard(
                  context,
                  icon: Icons.add,
                  label: "Nova",
                  route: "/transacao_form",
                  colorScheme: colorScheme,
                  isHighlight: true,
                ),
                _buildActionCard(
                  context,
                  icon: Icons.pie_chart_outline,
                  label: "Estatísticas",
                  route: "/estatisticas",
                  colorScheme: colorScheme,
                ),
                _buildActionCard(
                  context,
                  icon: Icons.settings_outlined,
                  label: "Ajustes",
                  route: "/configuracoes",
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniInfo({
    required IconData icon,
    required String label,
    required String value,
    required Color onColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6), // Menor
          decoration: BoxDecoration(
            color: onColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: onColor, size: 16), // Ícone menor
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: onColor.withValues(alpha: 0.7), fontSize: 11)),
            Text(value, style: TextStyle(color: onColor, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required ColorScheme colorScheme,
    bool isHighlight = false,
  }) {
    // Usando cores do tema para bordas
    final borderColor = isHighlight 
        ? Colors.transparent 
        : Colors.grey.withValues(alpha: 0.2); // Usando withValues corrigido

    return Material(
      color: isHighlight ? colorScheme.primary.withValues(alpha: 0.1) : colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          // Alinhamento compacto
          child: Row( // Mudei de Column para Row para ficar mais compacto horizontalmente
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22, // Ícone reduzido
                color: isHighlight ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13, // Texto reduzido
                  fontWeight: FontWeight.w600,
                  color: isHighlight ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}