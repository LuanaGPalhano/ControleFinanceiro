import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Imports do Banco e do Modelo
import 'package:flutter_application_1/modules/transacoes/transacao_model.dart';
import 'package:flutter_application_1/core/services/log_service.dart';
import 'package:flutter_application_1/data/database/db_helper.dart';


class TransacaoFormPage extends StatefulWidget {
  // Se recebermos essa variável, significa que é uma EDIÇÃO
  final Transacao? transacaoParaEditar;

  const TransacaoFormPage({super.key, this.transacaoParaEditar});

  @override
  State<TransacaoFormPage> createState() => _TransacaoFormPageState();
}

class _TransacaoFormPageState extends State<TransacaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  
  // 0 = Despesa, 1 = Receita
  int _tipoSelecionado = 0; 
  DateTime _dataSelecionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Lógica de EDIÇÃO: Se veio um item, preenche os campos
    if (widget.transacaoParaEditar != null) {
      final t = widget.transacaoParaEditar!;
      _descricaoController.text = t.descricao;
      // Converte o double para string com vírgula
      _valorController.text = t.valor.toStringAsFixed(2).replaceAll('.', ','); 
      _tipoSelecionado = t.tipo;
      _dataSelecionada = DateTime.parse(t.data);
      LogService.info("📝 Abrindo formulário para edição do ID: ${t.id}");
    } else {
      LogService.info("🆕 Abrindo formulário para nova transação");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = widget.transacaoParaEditar != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Editar Transação" : "Nova Transação"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SELETOR DE TIPO ---
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      label: "Despesa",
                      value: 0,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTypeButton(
                      label: "Receita",
                      value: 1,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- CAMPO VALOR ---
              TextFormField(
                controller: _valorController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: "Valor",
                  prefixText: "R\$ ",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o valor';
                  // Aceita vírgula ou ponto
                  if (double.tryParse(value.replaceAll(',', '.')) == null) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- CAMPO DESCRIÇÃO ---
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: "Descrição (Ex: Aluguel)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a descrição';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- CAMPO DATA ---
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Data",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_dataSelecionada),
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- BOTÃO SALVAR ---
              SizedBox(
                height: 50,
                child: FilledButton(
                  onPressed: _salvarTransacao,
                  child: Text(isEditing ? "ATUALIZAR" : "SALVAR"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para os botões de tipo
  Widget _buildTypeButton({
    required String label,
    required int value,
    required Color color,
  }) {
    final isSelected = _tipoSelecionado == value;
    return InkWell(
      onTap: () => setState(() => _tipoSelecionado = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  Future<void> _salvarTransacao() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Converte valor (troca virgula por ponto)
        final valorFormatado = double.parse(_valorController.text.replaceAll(',', '.'));

        final transacao = Transacao(
          id: widget.transacaoParaEditar?.id, // Se for edição, mantém o ID
          descricao: _descricaoController.text,
          valor: valorFormatado,
          data: _dataSelecionada.toIso8601String(),
          tipo: _tipoSelecionado,
        );

        if (widget.transacaoParaEditar == null) {
          // INSERT
          await DBHelper().insertTransacao(transacao);
        } else {
          // UPDATE
          await DBHelper().updateTransacao(transacao);
        }

        if (mounted) {
          Navigator.pop(context, true); // Retorna true para atualizar a lista
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(widget.transacaoParaEditar == null ? 'Salvo!' : 'Atualizado!')),
          );
        }
      } catch (e) {
        LogService.error("Erro ao salvar no formulário", e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar transação')),
        );
      }
    }
  }
}