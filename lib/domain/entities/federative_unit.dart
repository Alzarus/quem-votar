/// Unidades Federativas oficiais da Republica Federativa do Brasil e ambito nacional.
///
/// Codificacao padronizada para filtragem territorial de candidaturas eleitorais,
/// compreendendo as 27 unidades federativas (26 estados e o Distrito Federal)
/// e o identificador nacional de soberania (BR).
enum FederativeUnit {
  br(acronym: 'BR', name: 'Brasil'),
  ac(acronym: 'AC', name: 'Acre'),
  al(acronym: 'AL', name: 'Alagoas'),
  ap(acronym: 'AP', name: 'Amapá'),
  am(acronym: 'AM', name: 'Amazonas'),
  ba(acronym: 'BA', name: 'Bahia'),
  ce(acronym: 'CE', name: 'Ceará'),
  df(acronym: 'DF', name: 'Distrito Federal'),
  es(acronym: 'ES', name: 'Espírito Santo'),
  go(acronym: 'GO', name: 'Goiás'),
  ma(acronym: 'MA', name: 'Maranhão'),
  mt(acronym: 'MT', name: 'Mato Grosso'),
  ms(acronym: 'MS', name: 'Mato Grosso do Sul'),
  mg(acronym: 'MG', name: 'Minas Gerais'),
  pa(acronym: 'PA', name: 'Pará'),
  pb(acronym: 'PB', name: 'Paraíba'),
  pr(acronym: 'PR', name: 'Paraná'),
  pe(acronym: 'PE', name: 'Pernambuco'),
  pi(acronym: 'PI', name: 'Piauí'),
  rj(acronym: 'RJ', name: 'Rio de Janeiro'),
  rn(acronym: 'RN', name: 'Rio Grande do Norte'),
  rs(acronym: 'RS', name: 'Rio Grande do Sul'),
  ro(acronym: 'RO', name: 'Rondônia'),
  rr(acronym: 'RR', name: 'Roraima'),
  sc(acronym: 'SC', name: 'Santa Catarina'),
  sp(acronym: 'SP', name: 'São Paulo'),
  se(acronym: 'SE', name: 'Sergipe'),
  to(acronym: 'TO', name: 'Tocantins');

  final String acronym;
  final String name;

  const FederativeUnit({required this.acronym, required this.name});

  /// Indica se a unidade territorial representa a circunscricao nacional.
  bool get isNational => this == FederativeUnit.br;

  /// Indica se a unidade territorial corresponde ao Distrito Federal.
  bool get isFederalDistrict => this == FederativeUnit.df;

  /// Indica se a unidade territorial representa um estado federado.
  bool get isState => !isNational && !isFederalDistrict;

  /// Converte uma sigla textual (case-insensitive) na correspondente [FederativeUnit].
  ///
  /// Retorna `null` caso a sigla nao corresponda a nenhuma circunscricao catalogada.
  static FederativeUnit? fromAcronymOrNull(String? acronym) {
    if (acronym == null || acronym.trim().isEmpty) {
      return null;
    }
    final normalized = acronym.trim().toUpperCase();
    for (final unit in values) {
      if (unit.acronym == normalized) {
        return unit;
      }
    }
    return null;
  }

  /// Lista ordenada de unidades federativas, iniciando por BR seguido dos 27 estados e DF.
  static List<FederativeUnit> get allUnits => List.unmodifiable(values);
}
