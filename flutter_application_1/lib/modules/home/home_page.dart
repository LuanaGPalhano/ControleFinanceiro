import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/database/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart'; // Recurso Nativo
import 'package:flutter_application_1/core/services/log_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variáveis de Estado (Dados que mudam)
  double total = 0.0;
  double receitas = 0.0;
  double despesas = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  // Busca os dados reais no SQLite
  Future<void> _carregarDados() async {
    final dados = await DBHelper().getTotais();
    if (mounted) {
      setState(() {
        receitas = dados['receitas']!;
        despesas = dados['despesas']!;
        total = dados['total']!;
        isLoading = false;
      });
    }
  }

  // Função do Recurso Nativo (Compartilhar)
  void _compartilharResumo() {
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final texto = """
📊 *Resumo Financeiro*

💰 Saldo: ${currency.format(total)}
📈 Receitas: ${currency.format(receitas)}
📉 Despesas: ${currency.format(despesas)}

_Gerado pelo meu App Flutter!_
""";
    Share.share(texto);
  }

  // Navega e atualiza o saldo quando voltar
  void _navegarEAtualizar(String rota) async {
    await Navigator.pushNamed(context, rota);
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Detecta orientação
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Formatador de dinheiro
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');

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
          // BOTÃO NATIVO: COMPARTILHAR
          IconButton(
            onPressed: _compartilharResumo, 
            icon: const Icon(Icons.share),
            tooltip: 'Compartilhar',
            iconSize: 22,
          ),
          // BOTÃO REFRESH (Útil para testes)
          IconButton(
            onPressed: _carregarDados, 
            icon: const Icon(Icons.refresh),
            iconSize: 22,
          ),
        ],
      ),

      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==========================================
            // 1. CARD DE SALDO REAL
            // ==========================================
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: isLandscape ? 160 : double.infinity, 
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(isLandscape ? 16 : 20),
                decoration: BoxDecoration(
                  color: colorScheme.primary, 
                  borderRadius: BorderRadius.circular(16),
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Saldo Total",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: isLandscape ? 2 : 4), 
                    Text(
                      currency.format(total), // Valor do Banco
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLandscape ? 22 : 26, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: isLandscape ? 8 : 16),
                    
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMiniInfo(
                            icon: Icons.arrow_downward,
                            label: "Receitas",
                            value: currency.format(receitas),
                            onColor: Colors.white,
                            isCompact: isLandscape,
                          ),
                          Container(width: 1, height: 30, color: Colors.white24),
                          _buildMiniInfo(
                            icon: Icons.arrow_upward,
                            label: "Despesas",
                            value: currency.format(despesas),
                            onColor: Colors.white,
                            isCompact: isLandscape,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
            // 2. GRID DE BOTÕES (COM NAVEGAÇÃO REAL)
            // ==========================================
            GridView.count(
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isLandscape ? 4 : 2, 
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isLandscape ? 1.5 : 2.1, 
              
              children: [
                _buildActionCard(
                  context,
                  icon: Icons.swap_horiz,
                  label: "Transações",
                  onTap: () => _navegarEAtualizar("/transacoes"), // Atualiza ao voltar
                  colorScheme: colorScheme,
                ),
                _buildActionCard(
                  context,
                  icon: Icons.add,
                  label: "Nova",
                  onTap: () => _navegarEAtualizar("/transacao_form"), // Atualiza ao voltar
                  colorScheme: colorScheme,
                  isHighlight: true,
                ),
                _buildActionCard(
                  context,
                  icon: Icons.pie_chart_outline,
                  label: "Estatísticas",
                  onTap: () => _navegarEAtualizar("/estatisticas"),
                  colorScheme: colorScheme,
                ),
                _buildActionCard(
                  context,
                  icon: Icons.settings_outlined,
                  label: "Ajustes",
                  onTap: () => Navigator.pushNamed(context, "/configuracoes"),
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
    bool isCompact = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: onColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: onColor, size: isCompact ? 14 : 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: onColor.withValues(alpha: 0.7), fontSize: 11)),
            Text(value, style: TextStyle(color: onColor, fontWeight: FontWeight.bold, fontSize: isCompact ? 12 : 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap, // Mudei de String route para Function onTap
    required ColorScheme colorScheme,
    bool isHighlight = false,
  }) {
    final borderColor = isHighlight 
        ? Colors.transparent 
        : Colors.grey.withValues(alpha: 0.2);

    return Material(
      color: isHighlight ? colorScheme.primary.withValues(alpha: 0.1) : colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isHighlight ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Flexible( 
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isHighlight ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}