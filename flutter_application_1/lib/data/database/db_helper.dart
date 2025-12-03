import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_application_1/modules/transacoes/transacao_model.dart';
import 'package:flutter_application_1/core/services/log_service.dart'; // Import do Logger

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    LogService.info("🔄 Iniciando conexão com o SQLite...");
    
    String path = join(await getDatabasesPath(), 'finance.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        LogService.warning("⚠️ Criando nova tabela 'transacoes'...");
        await db.execute('''
          CREATE TABLE transacoes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            descricao TEXT,
            valor REAL,
            data TEXT,
            tipo INTEGER
          )
        ''');
      },
    );
  }

  // 1. Inserir (Salvar) com LOG
  Future<int> insertTransacao(Transacao transacao) async {
    final db = await database; // AQUI ESTAVA O ERRO "Undefined name 'database'"
    try {
      int id = await db.insert('transacoes', transacao.toMap());
      LogService.info("✅ Transação salva com ID: $id - Valor: ${transacao.valor}");
      return id;
    } catch (e, stack) {
      LogService.error("❌ Erro ao salvar transação", e, stack);
      rethrow;
    }
  }

  // 2. Listar Todas
  Future<List<Transacao>> getTransacoes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transacoes', orderBy: "data DESC");

    return List.generate(maps.length, (i) {
      return Transacao.fromMap(maps[i]);
    });
  }

  // 3. Somar Totais (ESSENCIAL PARA A HOME)
  Future<Map<String, double>> getTotais() async {
    final db = await database;
    final resultado = await db.rawQuery('SELECT tipo, SUM(valor) as total FROM transacoes GROUP BY tipo');
    
    double receitas = 0;
    double despesas = 0;

    for (var row in resultado) {
      if (row['tipo'] == 1) {
        receitas = (row['total'] as num?)?.toDouble() ?? 0.0;
      } else {
        despesas = (row['total'] as num?)?.toDouble() ?? 0.0;
      }
    }

    return {
      'receitas': receitas,
      'despesas': despesas,
      'total': receitas - despesas,
    };
  }

  // 4. Deletar
  Future<int> deleteTransacao(int id) async {
    final db = await database;
    LogService.warning("🗑️ Deletando transação ID: $id");
    return await db.delete('transacoes', where: 'id = ?', whereArgs: [id]);
  }
}