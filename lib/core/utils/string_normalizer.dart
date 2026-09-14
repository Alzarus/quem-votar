/// Utilitario para normalizacao de termos textuais de pesquisa eleitoral.
///
/// Converte caracteres com diacriticos para seus equivalentes basicos em caixa baixa,
/// viabilizando buscas lexicais flexiveis sem degradacao de performance.
abstract final class StringNormalizer {
  static const _withDiacritics = 'àáâãäåāăąèéêëēĕėęěìíîïĩīĭǐòóôõöōŏőùúûüũūŭůçćĉċčñńņňýÿŷ';
  static const _withoutDiacritics = 'aaaaaaaaaeeeeeeeeeiiiiiiiioooooooouuuuuuuucccccnnnnyyy';

  /// Normaliza o texto removendo espacos excedentes, diacriticos e convertendo para minusculas.
  static String normalize(String input) {
    if (input.isEmpty) return '';
    final trimmed = input.trim();
    if (trimmed.isEmpty) return '';

    final buffer = StringBuffer();
    final lower = trimmed.toLowerCase();

    for (var i = 0; i < lower.length; i++) {
      final char = lower[i];
      final index = _withDiacritics.indexOf(char);
      if (index != -1) {
        buffer.write(_withoutDiacritics[index]);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }
}
