import 'package:intl/intl.dart';

/// Utilitario estatico para formatacao monetaria no padrao brasileiro (BRL).
///
/// Converte valores numericos de ponto flutuante em strings no padrao oficial
/// "R$ 1.234,56", com tratamento para valores nulos ou zerados.
abstract final class CurrencyFormatter {
  static final NumberFormat _ptBrCurrency = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  /// Formata o valor numerico em moeda corrente brasileira.
  static String formatBrl(double? amount) {
    if (amount == null || amount == 0.0) {
      return 'R\$ 0,00';
    }
    return _ptBrCurrency.format(amount);
  }
}
