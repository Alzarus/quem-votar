import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter - Formatacao Monetaria BRL', () {
    test('deve formatar valor nulo como R\$ 0,00', () {
      final formatted = CurrencyFormatter.formatBrl(null);
      expect(formatted, equals('R\$ 0,00'));
    });

    test('deve formatar zero como R\$ 0,00', () {
      final formatted = CurrencyFormatter.formatBrl(0.0);
      expect(formatted, equals('R\$ 0,00'));
    });

    test('deve formatar valores positivos com separador decimal e milhar', () {
      final formatted = CurrencyFormatter.formatBrl(1250500.75);
      expect(formatted.contains('1.250.500,75'), isTrue);
      expect(formatted.contains('R\$'), isTrue);
    });
  });
}
