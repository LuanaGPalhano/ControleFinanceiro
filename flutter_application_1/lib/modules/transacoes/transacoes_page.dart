import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/database/db_helper.dart';
import 'package:intl/intl.dart'; // Para formatar R$ e Data
import 'transacao_model.dart';

class TransacoesPage extends StatefulWidget {
  const TransacoesPage({super.key});

  @override
  State<TransacoesPage> createState() => _TransacoesPageState();
}

class _TransacoesPageState extends State<TransacoesPage> {
  // Variável que guarda o futuro (a promessa da lista)
  late Future<List<Transacao>> _transacoesFuture;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _atualizarLista() {
    setState(() {
      _transacoesFuture = DBHelper().getTransacoes();
    });
  }

  // Função para deletar item do banco
  Future<void> _deletarTransacao(int id) async {
    await DBHelper().deleteTransacao(id);
    _atualizarLista(); // Recarrega a tela
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico")),
      
      // FutureBuilder constrói a tela baseado no estado do Banco de Dados
      body: FutureBuilder<List<Transacao>>(
        future: _transacoesFuture,
        builder: (context, snapshot) {
          
          // 1. Carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Lista Vazia ou Erro
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text("Nenhuma transação ainda."),
                ],
              ),
            );
          }

          // 3. Lista com Dados
          final transacoes = snapshot.data!;
          
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transacoes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = transacoes[index];
              final isReceita = item.tipo == 1;

              // Widget nativo para arrastar e excluir
              return Dismissible(
                key: Key(item.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  if (item.id != null) _deletarTransacao(item.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Transação removida")),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isReceita 
                          ? Colors.green.withValues(alpha: 0.1) 
                          : Colors.red.withValues(alpha: 0.1),
                      child: Icon(
                        isReceita ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isReceita ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      item.descricao,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(DateTime.parse(item.data)),
                    ),
                    trailing: Text(
                      NumberFormat.simpleCurrency(locale: 'pt_BR').format(item.valor),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isReceita ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      
      // Botão flutuante para adicionar rápido
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Espera voltar da tela de formulário
          final bool? salvou = await Navigator.pushNamed(context, '/transacao_form') as bool?;
          if (salvou == true) {
            _atualizarLista(); // Se salvou algo, atualiza a lista
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}