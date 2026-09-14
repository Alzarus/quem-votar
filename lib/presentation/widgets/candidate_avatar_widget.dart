import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';

/// Componente atomico acessivel para exibicao de fotografia oficial de urna.
///
/// Implementa anotacoes de leitor de tela (Semantics), resolucao de falhas com icone
/// institucional de contingencia e dimensionamento estrito conforme WCAG 2.1 AA.
class CandidateAvatarWidget extends StatelessWidget {
  const CandidateAvatarWidget({
    super.key,
    required this.candidateName,
    this.photoUrl,
    this.size = 64.0,
  });

  /// Nome de urna do candidato para descricao no leitor de tela.
  final String candidateName;

  /// URL da fotografia oficial fornecida pela API do TSE.
  final String? photoUrl;

  /// Dimensao diametral do avatar (largura e altura iguais).
  final double size;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final url = photoUrl?.trim();
    final hasValidUrl = url != null && url.isNotEmpty;

    return Semantics(
      image: true,
      label: 'Foto oficial de urna de $candidateName',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: semantic.borderSubtle,
          shape: BoxShape.circle,
          border: Border.all(color: semantic.borderSubtle, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: hasValidUrl ? _buildNetworkImage(url, semantic) : _buildFallbackIcon(semantic),
      ),
    );
  }

  Widget _buildNetworkImage(String url, AppSemanticColors semantic) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(semantic),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: size * 0.4,
            height: size * 0.4,
            child: CircularProgressIndicator(strokeWidth: 2.0, color: semantic.brandPrimary),
          ),
        );
      },
    );
  }

  Widget _buildFallbackIcon(AppSemanticColors semantic) {
    return Center(
      child: Icon(Icons.person_rounded, size: size * 0.55, color: semantic.textSecondary),
    );
  }
}
