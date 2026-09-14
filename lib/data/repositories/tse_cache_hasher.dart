import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:quem_votar/data/models/candidate_detail_dto.dart';
import 'package:quem_votar/data/models/candidate_list_envelope_dto.dart';
import 'package:quem_votar/data/models/election_dto.dart';

/// Utilitario para geracao de hashes deterministicos SHA-256 de integridade de dados do TSE.
///
/// Permite comparacao com o metadado gravado em `CacheMetadataTable` para deteccao de deltas.
abstract final class TseCacheHasher {
  /// Computa hash SHA-256 sobre a relacao consolidada de candidatos de uma circunscricao.
  static String hashCandidateList(CandidateListEnvelopeDto envelope) {
    final buffer = StringBuffer();
    buffer.write('${envelope.stateCode}:${envelope.roleCode}:${envelope.candidates.length}|');
    for (final candidate in envelope.candidates) {
      buffer.write(
        '${candidate.id}_${candidate.ballotNumber}_'
        '${candidate.rawStatusDescription}_${candidate.totalAssets ?? 0.0};',
      );
    }
    return sha256.convert(utf8.encode(buffer.toString())).toString();
  }

  /// Computa hash SHA-256 sobre a ficha detalhada e bens declarados de um candidato.
  static String hashCandidateDetail(CandidateDetailDto detail) {
    final buffer = StringBuffer();
    buffer.write(
      '${detail.id}_${detail.rawStatusDescription}_'
      '${detail.totalAssets}_${detail.assets.length}_${detail.runningMates.length}|',
    );
    for (final asset in detail.assets) {
      buffer.write('${asset.orderIndex}_${asset.amount};');
    }
    for (final mate in detail.runningMates) {
      buffer.write('${mate.candidateId}_${mate.isEligible};');
    }
    return sha256.convert(utf8.encode(buffer.toString())).toString();
  }

  /// Computa hash SHA-256 deterministico sobre a lista de pleitos eleitorais ordinarios.
  static String hashElections(List<ElectionDto> elections) {
    final buffer = StringBuffer();
    for (final election in elections) {
      buffer.write('${election.id}_${election.year}_${election.type}_${election.scope};');
    }
    return sha256.convert(utf8.encode(buffer.toString())).toString();
  }
}
