import 'package:flutter/material.dart';
import 'package:quem_votar/presentation/theme/app_semantic_colors.dart';
import 'package:quem_votar/presentation/theme/app_spacing.dart';
import 'package:quem_votar/presentation/theme/app_typography.dart';

/// Campo de busca textual acessivel para filtragem dinamica de candidaturas.
///
/// Implementa alvo ergonomico minimo de 48dp, botao de limpeza rapida,
/// rotulacao semantica compulsoria (WCAG 2.1 AA) e desacoplamento de debounce.
class CandidateListSearchInput extends StatefulWidget {
  final String initialQuery;
  final ValueChanged<String> onQueryChanged;

  const CandidateListSearchInput({super.key, this.initialQuery = '', required this.onQueryChanged});

  @override
  State<CandidateListSearchInput> createState() => _CandidateListSearchInputState();
}

class _CandidateListSearchInputState extends State<CandidateListSearchInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(covariant CandidateListSearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery && widget.initialQuery != _controller.text) {
      _controller.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    setState(() {});
    widget.onQueryChanged(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final hasText = _controller.text.isNotEmpty;

    return Semantics(
      label: 'Pesquisar candidatos por nome de urna ou número eleitoral',
      textField: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48.0),
        child: TextField(
          controller: _controller,
          style: AppTypography.bodyLarge.copyWith(color: semantic.textPrimary),
          cursorColor: semantic.brandPrimary,
          textInputAction: TextInputAction.search,
          decoration: _buildInputDecoration(semantic, hasText),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(AppSemanticColors semantic, bool hasText) {
    return InputDecoration(
      hintText: 'Nome de urna ou número...',
      hintStyle: AppTypography.bodyMedium.copyWith(color: semantic.textSecondary),
      prefixIcon: ExcludeSemantics(
        child: Icon(Icons.search, color: semantic.textSecondary, size: 22.0),
      ),
      suffixIcon: hasText ? _buildClearButton(semantic) : null,
      filled: true,
      fillColor: semantic.surfaceCard,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceMd,
        vertical: AppSpacing.spaceSm,
      ),
      border: _buildBorder(semantic.borderSubtle),
      enabledBorder: _buildBorder(semantic.borderSubtle),
      focusedBorder: _buildBorder(semantic.brandPrimary, width: 2.0),
    );
  }

  Widget _buildClearButton(AppSemanticColors semantic) {
    return Semantics(
      button: true,
      label: 'Limpar texto da pesquisa',
      child: SizedBox(
        width: 48.0,
        height: 48.0,
        child: IconButton(
          icon: Icon(Icons.clear, color: semantic.textSecondary, size: 20.0),
          onPressed: _clearSearch,
          tooltip: 'Limpar busca',
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
