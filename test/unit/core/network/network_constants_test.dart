import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/network/network_constants.dart';

void main() {
  group('NetworkConstants', () {
    test('deve conter URLs e tempos limites regulamentares', () {
      expect(
        NetworkConstants.tseDirectBaseUrl,
        equals('https://divulgacandcontas.tse.jus.br/divulga/rest/v1/'),
      );
      expect(NetworkConstants.webProxyBaseUrl, equals('/quemvotar/api/'));
      expect(NetworkConstants.connectTimeout.inSeconds, equals(8));
      expect(NetworkConstants.receiveTimeout.inSeconds, equals(8));
    });

    test('deve conter cabecalhos de contexto Akamai validos', () {
      expect(NetworkConstants.userAgentHeader, contains('Mozilla/5.0'));
      expect(NetworkConstants.refererHeader, equals('https://divulgacandcontas.tse.jus.br/'));
      expect(NetworkConstants.originHeader, equals('https://divulgacandcontas.tse.jus.br'));
      expect(NetworkConstants.acceptHeader, contains('application/json'));
    });
  });
}
