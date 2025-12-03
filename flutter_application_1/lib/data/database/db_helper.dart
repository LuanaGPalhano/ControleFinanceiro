import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_application_1/modules/transacoes/transacao_model.dart';
import 'package:flutter_application_1/core/services/log_service.dart';

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

  // --- MÉTODOS CRUD ---

  // 1. CREATE (Inserir)
  Future<int> insertTransacao(Transacao transacao) async {
    final db = await database;
    try {
      int id = await db.insert('transacoes', transacao.toMap());
      LogService.info("✅ Transação salva com ID: $id");
      return id;
    } catch (e, stack) {
      LogService.error("❌ Erro ao salvar", e, stack);
      rethrow;
    }
  }

  // 2. READ (Listar tudo)
  Future<List<Transacao>> getTransacoes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transacoes', orderBy: "data DESC");
    return List.generate(maps.length, (i) => Transacao.fromMap(maps[i]));
  }

  // 2.1 READ (Totais para a Home)
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

  // 3. UPDATE (Atualizar) - ESTA É A FUNÇÃO QUE ESTAVA FALTANDO
  Future<int> updateTransacao(Transacao transacao) async {
    final db = await database;
    LogService.info("📝 Atualizando transação ID: ${transacao.id}");
    return await db.update(
      'transacoes',
      transacao.toMap(),
      where: 'id = ?',
      whereArgs: [transacao.id],
    );
  }

  // 4. DELETE (Apagar)
  Future<int> deleteTransacao(int id) async {
    final db = await database;
    LogService.warning("🗑️ Deletando transação ID: $id");
    return await db.delete('transacoes', where: 'id = ?', whereArgs: [id]);
  }
}