import 'package:logger/logger.dart';

class LogService {
  // Configuração do Logger para ficar bonito no console
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Não mostra a pilha de métodos para logs simples
      errorMethodCount: 5, // Mostra pilha apenas em erros
      lineLength: 80, // Largura da linha
      colors: true, // Colorido
      printEmojis: true, // Emojis (🔥 para erro, 💡 para info)
    ),
  );

  // Mensagens Informativas (Ex: "App iniciou", "Tela carregou")
  static void info(String message) {
    _logger.i(message);
  }

  // Avisos (Ex: "Campo vazio", "Tentativa falhou")
  static void warning(String message) {
    _logger.w(message);
  }

  // Erros Graves (Ex: "Banco de dados falhou", "API caiu")
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}