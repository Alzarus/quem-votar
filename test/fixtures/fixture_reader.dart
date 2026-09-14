import 'dart:convert';
import 'dart:io';

/// Utilitario para carregamento e decodificacao de fixtures JSON em testes unitarios headless.
class TseFixtureReader {
  const TseFixtureReader._();

  /// Le o conteudo textual bruto de um arquivo localizado em test/fixtures/.
  static String readFixture(String fileName) {
    final candidatePaths = <String>[
      'test/fixtures/$fileName',
      '../test/fixtures/$fileName',
      '../../test/fixtures/$fileName',
    ];

    for (final path in candidatePaths) {
      final file = File(path);
      if (file.existsSync()) {
        return file.readAsStringSync();
      }
    }

    throw FileNotFoundException(
      'Arquivo de fixture "$fileName" nao localizado nos caminhos inspecionados: $candidatePaths',
    );
  }

  /// Le e deserializa um JSON objeto `Map<String, dynamic>`.
  static Map<String, dynamic> readJsonMap(String fileName) {
    final content = readFixture(fileName);
    final decoded = jsonDecode(content);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw FormatException(
      'Esperado Map<String, dynamic> no fixture "$fileName", mas recebido: ${decoded.runtimeType}',
    );
  }

  /// Le e deserializa um JSON array `List<dynamic>`.
  static List<dynamic> readJsonList(String fileName) {
    final content = readFixture(fileName);
    final decoded = jsonDecode(content);
    if (decoded is List<dynamic>) {
      return decoded;
    }
    throw FormatException(
      'Esperado List<dynamic> no fixture "$fileName", mas recebido: ${decoded.runtimeType}',
    );
  }
}

/// Excecao lancada quando uma fixture nao e localizada no sistema de arquivos.
class FileNotFoundException implements Exception {
  final String message;

  const FileNotFoundException(this.message);

  @override
  String toString() => 'FileNotFoundException: $message';
}
