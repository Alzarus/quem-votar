import 'package:equatable/equatable.dart';
import 'package:quem_votar/core/errors/failures.dart';
import 'package:quem_votar/domain/entities/candidate_asset.dart';
import 'package:quem_votar/domain/entities/candidate_detail.dart';
import 'package:quem_votar/presentation/blocs/candidate_detail/candidate_detail_event.dart';

/// Ciclo de vida da recuperacao e auditoria da ficha detalhada.
enum CandidateDetailStatus { initial, loading, success, failure }

/// Estado imutavel para a apresentacao e auditoria patrimonial da candidatura.
class CandidateDetailState extends Equatable {
  final CandidateDetailStatus status;
  final CandidateDetail? candidateDetail;
  final List<CandidateAsset> sortedAssets;
  final double totalAssetsAmount;
  final CandidateAssetSortOption assetSortOption;
  final Failure? failure;
  final bool isRefreshing;

  // Parametros ativos da consulta atual
  final int? activeYear;
  final String? activeUfOrMun;
  final int? activeElectionId;
  final int? activeCandidateId;

  const CandidateDetailState({
    required this.status,
    this.candidateDetail,
    required this.sortedAssets,
    required this.totalAssetsAmount,
    required this.assetSortOption,
    this.failure,
    this.isRefreshing = false,
    this.activeYear,
    this.activeUfOrMun,
    this.activeElectionId,
    this.activeCandidateId,
  });

  /// Fabrica de inicializacao neutra sem selecao ativa.
  factory CandidateDetailState.initial() => const CandidateDetailState(
    status: CandidateDetailStatus.initial,
    candidateDetail: null,
    sortedAssets: [],
    totalAssetsAmount: 0.0,
    assetSortOption: CandidateAssetSortOption.descendingValue,
    failure: null,
    isRefreshing: false,
  );

  /// Cria copia imutavel com substituicao parametrica e anulacao segura.
  CandidateDetailState copyWith({
    CandidateDetailStatus? status,
    CandidateDetail? Function()? candidateDetail,
    List<CandidateAsset>? sortedAssets,
    double? totalAssetsAmount,
    CandidateAssetSortOption? assetSortOption,
    Failure? Function()? failure,
    bool? isRefreshing,
    int? activeYear,
    String? activeUfOrMun,
    int? activeElectionId,
    int? activeCandidateId,
  }) {
    return CandidateDetailState(
      status: status ?? this.status,
      candidateDetail: candidateDetail != null ? candidateDetail() : this.candidateDetail,
      sortedAssets: sortedAssets ?? this.sortedAssets,
      totalAssetsAmount: totalAssetsAmount ?? this.totalAssetsAmount,
      assetSortOption: assetSortOption ?? this.assetSortOption,
      failure: failure != null ? failure() : this.failure,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      activeYear: activeYear ?? this.activeYear,
      activeUfOrMun: activeUfOrMun ?? this.activeUfOrMun,
      activeElectionId: activeElectionId ?? this.activeElectionId,
      activeCandidateId: activeCandidateId ?? this.activeCandidateId,
    );
  }

  /// Indica se ha bens patrimoniais declarados pelo candidato.
  bool get hasAssets => sortedAssets.isNotEmpty;

  /// Quantidade total de bens patrimoniais declarados.
  int get assetsCount => sortedAssets.length;

  /// Indica se a candidatura possui membros de chapa ou suplentes declarados.
  bool get hasRunningMates => (candidateDetail?.runningMates.isNotEmpty ?? false);

  /// Indica se ha link ou documento de proposta de governo registrado.
  bool get hasProposalDocument {
    final url = candidateDetail?.proposalDocumentUrl;
    return url != null && url.trim().isNotEmpty;
  }

  /// Indica se ha teto de gastos estipulado para segundo turno.
  bool get isSecondTurnExpenseAvailable => candidateDetail?.maxCampaignExpenseSecondTurn != null;

  @override
  List<Object?> get props => [
    status,
    candidateDetail,
    sortedAssets,
    totalAssetsAmount,
    assetSortOption,
    failure,
    isRefreshing,
    activeYear,
    activeUfOrMun,
    activeElectionId,
    activeCandidateId,
  ];
}
