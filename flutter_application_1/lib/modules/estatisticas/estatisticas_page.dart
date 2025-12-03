import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/data/database/db_helper.dart';
import 'package:intl/intl.dart';

class EstatisticasPage extends StatefulWidget {
  const EstatisticasPage({super.key});

  @override
  State<EstatisticasPage> createState() => _EstatisticasPageState();
}

class _EstatisticasPageState extends State<EstatisticasPage> {
  double receitas = 0.0;
  double despesas = 0.0;
  double total = 0.0;
  bool isLoading = true;

  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final dados = await DBHelper().getTotais();
    if (mounted) {
      setState(() {
        receitas = (dados['receitas'] ?? 0).toDouble();
        despesas = (dados['despesas'] ?? 0).toDouble();
        total = receitas + despesas;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');

    final bool isEmpty = total == 0;

    return Scaffold(
      appBar: AppBar(title: const Text("Estatísticas")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        "Visão Geral",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),

                      // GRÁFICO
                      SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (event, pieResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieResponse == null ||
                                      pieResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 2,
                            centerSpaceRadius: 60,
                            sections: _showingSections(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // LEGENDAS
                      _buildIndicator(
                        color: Colors.green,
                        text: "Receitas",
                        value: receitas,
                        total: total,
                        isSquare: false,
                        textColor: colorScheme.onSurface,
                      ),
                      const SizedBox(height: 12),
                      _buildIndicator(
                        color: Colors.redAccent,
                        text: "Despesas",
                        value: despesas,
                        total: total,
                        isSquare: false,
                        textColor: colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
    );
  }

  // FATIAS DO GRÁFICO
  List<PieChartSectionData> _showingSections() {
    return List.generate(2, (i) {
      final bool isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20.0 : 14.0;
      final double radius = isTouched ? 60.0 : 50.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.redAccent,
            value: despesas,
            title: '${((despesas / total) * 100).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );

        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: receitas,
            title: '${((receitas / total) * 100).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );

        default:
          throw Error();
      }
    });
  }

  // SEM DADOS
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pie_chart_outline,
              size: 80, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text("Adicione transações para ver o gráfico."),
        ],
      ),
    );
  }

  // INDICADOR COM BARRA DE PROGRESSO
  Widget _buildIndicator({
    required Color color,
    required String text,
    required double value,
    required double total,
    required bool isSquare,
    required Color textColor,
  }) {
    final currency = NumberFormat.simpleCurrency(locale: 'pt_BR');

    // CORREÇÃO DO ERRO → SEMPRE double!!!
    final double percent = total == 0 ? 0.0 : value / total;

    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currency.format(value),
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                value: percent, // agora é DOUBLE, sem erro
                backgroundColor: color.withOpacity(0.1),
                color: color,
                minHeight: 4,
                borderRadius: BorderRadius.circular(4),
              ),
            )
          ],
        )
      ],
    );
  }
}
