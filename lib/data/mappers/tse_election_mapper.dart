import 'package:drift/drift.dart';
import 'package:quem_votar/data/database/app_database.dart';
import 'package:quem_votar/data/models/election_dto.dart';
import 'package:quem_votar/domain/entities/election.dart';

/// Mapper responsavel pela conversao de modelos de pleito eleitoral do TSE.
///
/// Realiza a transformacao entre [ElectionDto], [ElectionData] (Drift) e [Election] (Dominio).
abstract final class TseElectionMapper {
  /// Converte instancia de [ElectionDto] para a entidade de dominio [Election].
  static Election fromDto(ElectionDto dto) {
    return Election(
      id: dto.id,
      year: dto.year,
      name: dto.name,
      description: dto.description,
      type: dto.type,
      scope: dto.scope,
      electionDate: dto.electionDate,
    );
  }

  /// Converte registro de persistencia [ElectionData] para a entidade de dominio [Election].
  static Election fromData(ElectionData data) {
    return Election(
      id: data.id,
      year: data.ano,
      name: data.nome,
      description: data.descricao,
      type: data.tipo,
      scope: data.abrangencia,
      electionDate: data.dataEleicao,
    );
  }

  /// Converte [ElectionDto] em [ElectionsTableCompanion] para gravacao relacional via Drift.
  static ElectionsTableCompanion toCompanion(
    ElectionDto dto, {
    int turno = 1,
    String situacao = 'Oficial',
  }) {
    return ElectionsTableCompanion(
      id: Value(dto.id),
      ano: Value(dto.year),
      nome: Value(dto.name),
      descricao: Value(dto.description),
      tipo: Value(dto.type),
      abrangencia: Value(dto.scope),
      turno: Value(turno),
      dataEleicao: Value(dto.electionDate),
      situacao: Value(situacao),
    );
  }
}
