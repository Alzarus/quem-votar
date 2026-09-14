import 'package:flutter_test/flutter_test.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/mappers/tse_asset_mapper.dart';
import 'package:quem_votar/data/models/candidate_asset_dto.dart';
import 'package:quem_votar/domain/entities/candidate_asset.dart';

void main() {
  group('TseAssetMapper - Mapeamento de Bens Declarados', () {
    test('deve converter CandidateAssetDto em entidade de dominio CandidateAsset', () {
      const dto = CandidateAssetDto(
        orderIndex: 1,
        category: 'Apartamento',
        description: 'APARTAMENTO RESIDENCIAL',
        amount: 687091.02,
        updatedAt: '2022-08-26',
      );

      final entity = TseAssetMapper.fromDto(dto);

      expect(entity, isA<CandidateAsset>());
      expect(entity.orderIndex, equals(1));
      expect(entity.category, equals('Apartamento'));
      expect(entity.description, equals('APARTAMENTO RESIDENCIAL'));
      expect(entity.amount, equals(687091.02));
      expect(entity.updatedAt, equals('2022-08-26'));
    });

    test('deve converter CandidateAssetData do Drift em CandidateAsset', () {
      const data = CandidateAssetData(
        id: 1,
        candidateId: 280001612393,
        orderIndex: 2,
        category: 'Veiculo automotor',
        description: 'TOYOTA COROLLA',
        amount: 105000.0,
        updatedAt: '2022-08-26',
      );

      final entity = TseAssetMapper.fromData(data);

      expect(entity.orderIndex, equals(2));
      expect(entity.category, equals('Veiculo automotor'));
      expect(entity.amount, equals(105000.0));
    });

    test('deve converter CandidateAssetDto em CandidateAssetsTableCompanion', () {
      const dto = CandidateAssetDto(
        orderIndex: 1,
        category: 'Apartamento',
        description: 'APARTAMENTO',
        amount: 500000.0,
        updatedAt: '2026-09-01',
      );

      final companion = TseAssetMapper.toCompanion(dto, candidateId: 999);

      expect(companion.candidateId.value, equals(999));
      expect(companion.orderIndex.value, equals(1));
      expect(companion.category.value, equals('Apartamento'));
      expect(companion.description.value, equals('APARTAMENTO'));
      expect(companion.amount.value, equals(500000.0));
      expect(companion.updatedAt.value, equals('2026-09-01'));
    });
  });
}
