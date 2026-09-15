import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/core/network/url_launcher_service.dart';

class FakeUrlLauncherService implements UrlLauncherService {
  String? lastLaunchedUrl;
  bool shouldSucceed = true;

  @override
  Future<bool> launchCandidateUrl(String rawUrl) async {
    final cleanUrl = rawUrl.trim();
    if (cleanUrl.isEmpty) return false;
    lastLaunchedUrl = cleanUrl;
    return shouldSucceed;
  }
}

void main() {
  group('UrlLauncherService - Contrato e Regras de Negocio', () {
    late FakeUrlLauncherService fakeService;

    setUp(() {
      fakeService = FakeUrlLauncherService();
    });

    test('deve rejeitar URLs vazias ou compostas por espacos em branco', () async {
      final resultEmpty = await fakeService.launchCandidateUrl('');
      final resultSpaces = await fakeService.launchCandidateUrl('   ');

      expect(resultEmpty, isFalse);
      expect(resultSpaces, isFalse);
      expect(fakeService.lastLaunchedUrl, isNull);
    });

    test('deve registrar e despachar URL valida com sucesso', () async {
      const target = 'https://divulgacandcontas.tse.jus.br/proposta.pdf';
      final result = await fakeService.launchCandidateUrl(target);

      expect(result, isTrue);
      expect(fakeService.lastLaunchedUrl, equals(target));
    });

    test('DefaultUrlLauncherService deve rejeitar string vazia sem excecao', () async {
      const defaultService = DefaultUrlLauncherService();
      final result = await defaultService.launchCandidateUrl('');

      expect(result, isFalse);
    });
  });
}
