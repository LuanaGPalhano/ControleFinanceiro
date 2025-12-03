import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/database/db_helper.dart';
import 'package:flutter_application_1/modules/transacoes/transacao_model.dart';
import 'package:intl/intl.dart';
import 'transacao_form_page.dart'; // Importe a página de formulário

class TransacoesPage extends StatefulWidget {
  const TransacoesPage({super.key});

  @override
  State<TransacoesPage> createState() => _TransacoesPageState();
}

class _TransacoesPageState extends State<TransacoesPage> {
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

  Future<void> _deletarTransacao(int id) async {
    await DBHelper().deleteTransacao(id);
    _atualizarLista();
  }

  // --- FUNÇÃO NOVA: NAVEGAR PARA EDITAR ---
  void _editarTransacao(Transacao transacao) async {
    // Abre o formulário passando a transação clicada
    final bool? salvou = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransacaoFormPage(transacaoParaEditar: transacao),
      ),
    );

    // Se voltou com "true" (salvou), atualiza a lista
    if (salvou == true) {
      _atualizarLista();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Histórico")),
      
      body: FutureBuilder<List<Transacao>>(
        future: _transacoesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text("Nenhuma transação ainda."),
                ],
              ),
            );
          }

          final transacoes = snapshot.data!;
          
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transacoes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = transacoes[index];
              final isReceita = item.tipo == 1;

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
                onDismissed: (_) {
                  if (item.id != null) _deletarTransacao(item.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Transação removida")),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    // --- AQUI ESTÁ O SEGREDO DO CLIQUE ---
                    onTap: () => _editarTransacao(item), 
                    // -------------------------------------
                    
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: isReceita 
                          ? Colors.green.withOpacity(0.1) 
                          : Colors.red.withOpacity(0.1),
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
      
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? salvou = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransacaoFormPage()),
          );
          if (salvou == true) _atualizarLista();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}