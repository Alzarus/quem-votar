import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/utils/debounce_transformer.dart';

void main() {
  group('debounceTransformer', () {
    test('deve processar apenas o ultimo evento apos intervalo de resguardo', () async {
      final inputController = StreamController<String>();
      final results = <String>[];

      final transformer = debounceTransformer<String>(const Duration(milliseconds: 50));
      final stream = transformer(inputController.stream, (event) => Stream.value(event));
      final sub = stream.listen(results.add);

      inputController.add('a');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      inputController.add('ab');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      inputController.add('abc');

      // Antes do vencimento da duracao de 50ms, nada deve ter sido emitido
      expect(results, isEmpty);

      await Future<void>.delayed(const Duration(milliseconds: 70));
      expect(results, equals(['abc']));

      await sub.cancel();
      await inputController.close();
    });

    test('deve emitir multiplos eventos quando espacados alem da duracao', () async {
      final inputController = StreamController<String>();
      final results = <String>[];

      final transformer = debounceTransformer<String>(const Duration(milliseconds: 30));
      final stream = transformer(inputController.stream, (event) => Stream.value(event));
      final sub = stream.listen(results.add);

      inputController.add('primeiro');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(results, equals(['primeiro']));

      inputController.add('segundo');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(results, equals(['primeiro', 'segundo']));

      await sub.cancel();
      await inputController.close();
    });
  });
}
