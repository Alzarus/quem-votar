/// Codificacao padronizada dos cargos eletivos oficiais da Justica Eleitoral (TSE).
///
/// Codigos numericos correspondentes aos cargos catalogados na tabela oficial
/// de cargos do Tribunal Superior Eleitoral (codigos 1 a 13).
enum ElectionRole {
  president(
    code: 1,
    title: 'Presidente',
    shortTitle: 'P',
    isMajoritarian: true,
    isExecutive: true,
    isTitular: true,
  ),
  vicePresident(
    code: 2,
    title: 'Vice-Presidente',
    shortTitle: 'VP',
    isMajoritarian: true,
    isExecutive: true,
    isTitular: false,
  ),
  governor(
    code: 3,
    title: 'Governador',
    shortTitle: 'GE',
    isMajoritarian: true,
    isExecutive: true,
    isTitular: true,
  ),
  viceGovernor(
    code: 4,
    title: 'Vice-Governador',
    shortTitle: 'VGE',
    isMajoritarian: true,
    isExecutive: true,
    isTitular: false,
  ),
  senator(
    code: 5,
    title: 'Senador',
    shortTitle: 'S',
    isMajoritarian: true,
    isExecutive: false,
    isTitular: true,
  ),
  federalDeputy(
    code: 6,
    title: 'Deputado Federal',
    shortTitle: 'DF',
    isMajoritarian: false,
    isExecutive: false,
    isTitular: true,
  ),
  stateDeputy(
    code: 7,
    title: 'Deputado Estadual',
    shortTitle: 'DE',
    isMajoritarian: false,
    isExecutive: false,
    isTitular: true,
  ),
  districtDeputy(
    code: 8,
    title: 'Deputado Distrital',
    shortTitle: 'DD',
    isMajoritarian: false,
    isExecutive: false,
    isTitular: true,
  ),
  firstAlternateSenator(
    code: 9,
    title: '1º Suplente Senador',
    shortTitle: '1S',
    isMajoritarian: true,
    isExecutive: false,
    isTitular: false,
  ),
  secondAlternateSenator(
    code: 10,
    title: '2º Suplente Senador',
    shortTitle: '2S',
    isMajoritarian: true,
    isExecutive: false,
    isTitular: false,
  ),
  mayor(
    code: 11,
    title: 'Prefeito',
    shortTitle: 'PF',
    isMajoritarian: true,
    isExecutive: true,
    isTitular: true,
  ),
  viceMayor(
    code: 12,
    title: 'Vice-Prefeito',
    shortTitle: 'VPF',
    isMajoritarian: true,
    isExecutive: true,
    isTitular: false,
  ),
  councilor(
    code: 13,
    title: 'Vereador',
    shortTitle: 'VR',
    isMajoritarian: false,
    isExecutive: false,
    isTitular: true,
  );

  final int code;
  final String title;
  final String shortTitle;
  final bool isMajoritarian;
  final bool isExecutive;
  final bool isTitular;

  const ElectionRole({
    required this.code,
    required this.title,
    required this.shortTitle,
    required this.isMajoritarian,
    required this.isExecutive,
    required this.isTitular,
  });

  /// Determina se o cargo segue o sistema eleitoral proporcional.
  bool get isProportional => !isMajoritarian;

  /// Retorna a instancia de [ElectionRole] a partir do codigo numerico do TSE.
  ///
  /// Retorna `null` caso o codigo nao corresponda a um cargo oficial catalogado.
  static ElectionRole? fromCodeOrNull(int code) {
    for (final role in values) {
      if (role.code == code) {
        return role;
      }
    }
    return null;
  }
}
