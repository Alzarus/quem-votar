import 'package:drift/drift.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/models/candidate_asset_dto.dart';
import 'package:quem_votar/domain/entities/candidate_asset.dart';

/// Mapper responsavel pela conversao de itens de bens patrimoniais de candidatos.
///
/// Integra [CandidateAssetDto], [CandidateAssetData] (Drift) e [CandidateAsset] (Dominio).
abstract final class TseAssetMapper {
  /// Converte instancia de DTO para a entidade de dominio pura [CandidateAsset].
  static CandidateAsset fromDto(CandidateAssetDto dto) {
    return CandidateAsset(
      orderIndex: dto.orderIndex,
      category: dto.category,
      description: dto.description,
      amount: dto.amount,
      updatedAt: dto.updatedAt,
    );
  }

  /// Converte entidade relacional persistida no SQLite para a entidade [CandidateAsset].
  static CandidateAsset fromData(CandidateAssetData data) {
    return CandidateAsset(
      orderIndex: data.orderIndex,
      category: data.category,
      description: data.description,
      amount: data.amount,
      updatedAt: data.updatedAt,
    );
  }

  /// Converte DTO em registro relacional [CandidateAssetsTableCompanion] para persistencia.
  static CandidateAssetsTableCompanion toCompanion(
    CandidateAssetDto dto, {
    required int candidateId,
  }) {
    return CandidateAssetsTableCompanion(
      candidateId: Value(candidateId),
      orderIndex: Value(dto.orderIndex),
      category: Value(dto.category),
      description: Value(dto.description),
      amount: Value(dto.amount),
      updatedAt: Value(dto.updatedAt),
    );
  }
}
