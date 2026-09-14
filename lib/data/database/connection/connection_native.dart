import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Fabrica de conexao SQLite nativa para plataformas moveis e desktop (Windows/Android/iOS).
///
/// Utiliza NativeDatabase.createInBackground para processamento assincrono fora da thread de UI.
QueryExecutor openConnection({bool logStatements = false}) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'quem_votar.sqlite'));
    return NativeDatabase.createInBackground(file, logStatements: logStatements);
  });
}
