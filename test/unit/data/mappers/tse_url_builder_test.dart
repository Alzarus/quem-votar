import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/mappers/tse_url_builder.dart';

void main() {
  group('TseUrlBuilder - Construcao de Enderecos Canonicos do TSE', () {
    const electionId = 20322002026;
    const candidateId = 280001612393;

    test('deve construir URL canonica de foto de urna em alta resolucao', () {
      final url = TseUrlBuilder.buildUrnaPhotoUrl(
        electionId: electionId,
        candidateId: candidateId,
        ufOrMun: 'BR',
      );

      expect(
        url,
        equals(
          'https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo/img/20322002026/280001612393/BR',
        ),
      );
    });

    test('deve normalizar espacos e caixa da sigla territorial para alta resolucao', () {
      final url = TseUrlBuilder.buildUrnaPhotoUrl(
        electionId: electionId,
        candidateId: candidateId,
        ufOrMun: ' sp ',
      );

      expect(
        url,
        equals(
          'https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo/img/20322002026/280001612393/SP',
        ),
      );
    });

    test('deve construir URL de thumbnail em baixa resolucao com versao padrao', () {
      final url = TseUrlBuilder.buildThumbnailPhotoUrl(
        electionId: electionId,
        candidateId: candidateId,
      );

      expect(
        url,
        equals(
          'https://divulgacandcontas.tse.jus.br/divulga/rest/v1/candidatura/buscar/foto/20322002026/280001612393/1',
        ),
      );
    });

    test('deve construir URL de thumbnail com versao customizada', () {
      final url = TseUrlBuilder.buildThumbnailPhotoUrl(
        electionId: electionId,
        candidateId: candidateId,
        version: 2,
      );

      expect(
        url,
        equals(
          'https://divulgacandcontas.tse.jus.br/divulga/rest/v1/candidatura/buscar/foto/20322002026/280001612393/2',
        ),
      );
    });

    test('deve construir URL oficial de documento anexo ou proposta de governo', () {
      const fileId = 280010929672;
      final url = TseUrlBuilder.buildProposalDocumentUrl(fileId);

      expect(
        url,
        equals('https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo/doc/280010929672'),
      );
    });

    test('deve reescrever para rota do micro-proxy quando isWeb for verdadeiro', () {
      final urnaUrl = TseUrlBuilder.buildUrnaPhotoUrl(
        electionId: electionId,
        candidateId: candidateId,
        ufOrMun: 'BR',
        isWeb: true,
      );
      final thumbUrl = TseUrlBuilder.buildThumbnailPhotoUrl(
        electionId: electionId,
        candidateId: candidateId,
        isWeb: true,
      );
      final docUrl = TseUrlBuilder.buildProposalDocumentUrl(280010929672, isWeb: true);

      expect(urnaUrl, equals('/quemvotar/api/arquivo/img/20322002026/280001612393/BR'));
      expect(thumbUrl, equals('/quemvotar/api/candidatura/buscar/foto/20322002026/280001612393/1'));
      expect(docUrl, equals('/quemvotar/api/arquivo/doc/280010929672'));
    });

    test('deve preservar URL inalterada quando formatMediaUrl executado com isWeb falso', () {
      const raw = 'https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo/img/1/2/BR';
      final formatted = TseUrlBuilder.formatMediaUrl(raw, isWeb: false);

      expect(formatted, equals(raw));
    });
  });
}
