import 'package:equatable/equatable.dart';

/// DTO representativo de arquivo documental protocolado na candidatura.
///
/// Mapeia cada elemento do array `arquivos[]` da ficha detalhada, viabilizando
/// a identificacao automatica de propostas de governo (`codTipo == "5"`).
class CandidateFileDto extends Equatable {
  final int fileId;
  final String fileName;
  final String pathUrl;
  final String fileType;
  final String typeCode;

  const CandidateFileDto({
    required this.fileId,
    required this.fileName,
    required this.pathUrl,
    required this.fileType,
    required this.typeCode,
  });

  /// Instancia DTO a partir de mapa JSON com parsing defensivo.
  factory CandidateFileDto.fromJson(Map<String, dynamic> json) {
    return CandidateFileDto(
      fileId: (json['idArquivo'] as num?)?.toInt() ?? 0,
      fileName: json['nome'] as String? ?? '',
      pathUrl: json['url'] as String? ?? '',
      fileType: json['tipo'] as String? ?? '',
      typeCode: json['codTipo']?.toString() ?? '',
    );
  }

  /// Determina se o arquivo protocolado corresponde a proposta oficial de governo.
  bool get isGovernmentProposal => typeCode == '5';

  /// Converte a instancia em mapa serializavel.
  Map<String, dynamic> toJson() {
    return {
      'idArquivo': fileId,
      'nome': fileName,
      'url': pathUrl,
      'tipo': fileType,
      'codTipo': typeCode,
    };
  }

  @override
  List<Object?> get props => [fileId, fileName, pathUrl, fileType, typeCode];
}
