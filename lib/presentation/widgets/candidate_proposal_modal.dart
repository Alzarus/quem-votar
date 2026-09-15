import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quem_votar/core/network/url_launcher_service.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Modal acessivel para visualizacao e gestao do documento de proposta de governo.
///
/// Provê isolamento de historico de navegacao no PWA, botao explicito de encerramento
/// (Icons.close) e despacho seguro para abertura externa sem encerrar a aplicacao.
class CandidateProposalModal extends StatelessWidget {
  final String candidateName;
  final String proposalUrl;
  final UrlLauncherService urlLauncherService;
  final Future<void> Function(String text)? onCopy;

  const CandidateProposalModal({
    super.key,
    required this.candidateName,
    required this.proposalUrl,
    this.urlLauncherService = const DefaultUrlLauncherService(),
    this.onCopy,
  });

  /// Exibe o modal como folha inferior acessivel.
  static Future<void> show(
    BuildContext context, {
    required String candidateName,
    required String proposalUrl,
    UrlLauncherService urlLauncherService = const DefaultUrlLauncherService(),
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CandidateProposalModal(
        candidateName: candidateName,
        proposalUrl: proposalUrl,
        urlLauncherService: urlLauncherService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600.0),
        child: Container(
          decoration: BoxDecoration(
            color: semantic.surfaceCard,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
            border: Border.all(color: semantic.borderSubtle),
          ),
          padding: AppSpacing.edgeInsetsMd,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, semantic),
              const SizedBox(height: AppSpacing.spaceSm),
              _buildCandidateInfo(semantic),
              const SizedBox(height: AppSpacing.spaceSm),
              _buildDocumentNotice(semantic),
              const SizedBox(height: AppSpacing.spaceMd),
              _buildActions(context, semantic),
              const SizedBox(height: AppSpacing.spaceSm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppSemanticColors semantic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Diretrizes e Plano de Governo',
            style: AppTypography.titleMedium.copyWith(
              color: semantic.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Semantics(
          button: true,
          label: 'Fechar visualizador de proposta de governo',
          child: ConstrainedBox(
            constraints: AppTouchTarget.minConstraints,
            child: IconButton(
              icon: Icon(Icons.close, color: semantic.textPrimary),
              tooltip: 'Fechar',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCandidateInfo(AppSemanticColors semantic) {
    return Text(
      'Candidatura: $candidateName',
      style: AppTypography.bodyMedium.copyWith(
        color: semantic.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDocumentNotice(AppSemanticColors semantic) {
    return Container(
      padding: AppSpacing.edgeInsetsSm,
      decoration: BoxDecoration(
        color: semantic.surfaceBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: semantic.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20.0, color: semantic.brandPrimary),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(
            child: Text(
              'Documento registrado perante a Justica Eleitoral (TSE). '
              'Para preservar sua sessao no aplicativo, o arquivo sera aberto em janela isolada.',
              style: AppTypography.labelSmall.copyWith(color: semantic.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, AppSemanticColors semantic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48.0),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: semantic.brandPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            icon: const Icon(Icons.open_in_new, size: 20.0),
            label: const Text('Abrir Documento PDF (Nova Janela)'),
            onPressed: () => _handleOpenExternal(context),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48.0),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: semantic.textPrimary,
              side: BorderSide(color: semantic.borderSubtle),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            icon: const Icon(Icons.copy_outlined, size: 20.0),
            label: const Text('Copiar Link da Proposta'),
            onPressed: () => _handleCopyLink(context),
          ),
        ),
      ],
    );
  }

  Future<void> _handleOpenExternal(BuildContext context) async {
    final success = await urlLauncherService.launchCandidateUrl(proposalUrl);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel abrir o documento da proposta de governo.')),
      );
    }
  }

  Future<void> _handleCopyLink(BuildContext context) async {
    try {
      if (onCopy != null) {
        await onCopy!(proposalUrl);
      } else {
        await Clipboard.setData(ClipboardData(text: proposalUrl));
      }
    } catch (_) {
      // Tratamento defensivo para ambientes de teste headless
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link da proposta copiado para a area de transferencia.')),
      );
    }
  }
}
