# Mapeamento de Contratos e Modelos de Dados (API Specifications)

## Projeto: Plataforma de Transparencia Civica e Acompanhamento Eleitoral
**Documento:** CON-001  
**Classificacao:** Especificacao de Interface e Dicionario de Dados Oficial  
**Revisao:** 2.0.0  
**Data:** 11 de setembro de 2026  

---

## 1. Engenharia Reversa da API DivulgaCandContas (TSE)

O sistema oficial de divulgacao do Tribunal Superior Eleitoral opera sob o prefixo:
`https://divulgacandcontas.tse.jus.br/divulga/rest/v1`

### 1.1 Tabela Exaustiva de Endpoints Oficiais

| Modulo Funcional | Metodo | Rota do TSE | Parametros e Formato | Finalidade e Descricao |
|---|---|---|---|---|
| **Eleicoes** | `GET` | `/eleicao/eleicoes` | Nenhum | Catalogo completo de pleitos registrados na Justica Eleitoral com seus respectivos identificadores unicos (`idEleicao`). |
| **Eleicoes** | `GET` | `/eleicao/ordinarias` | Nenhum | Relacao dos pleitos regulares e ordinarios do calendario eleitoral nacional. |
| **Eleicoes** | `GET` | `/eleicao/suplementares/{ano}/{siglaUf}` | `ano`: Inteiro (ex: 2026)<br>`siglaUf`: Sigla do Estado | Identificadores especificos de eleicoes suplementares convocadas para determinada circunscricao. |
| **Territorio** | `GET` | `/eleicao/listar/municipios/{idEleicao}/{siglaUf}/municipios` | `idEleicao`: Inteiro<br>`siglaUf`: Sigla do Estado | Lista de municipios daquela UF acompanhados dos respectivos codigos oficiais do TSE (ex: Feira de Santana = 35157). |
| **Territorio** | `GET` | `/eleicao/listar/municipios/{idEleicao}/{codigoMunicipio}/cargos` | `idEleicao`: Inteiro<br>`codigoMunicipio`: Inteiro | Relacao dos cargos eletivos em disputa no municipio especificado. |
| **Territorio** | `GET` | `/eleicao/cargos-por-uf/{idEleicao}/{siglaUf}` | `idEleicao`: Inteiro<br>`siglaUf`: Sigla UF ou `BR` | Relacao de cargos estaduais, distritais e federais em disputa naquele pleito. |
| **Candidaturas** | `GET` | `/candidatura/listar/{ano}/{siglaUf}/{idEleicao}/{codigoCargo}/candidatos` | `ano`: Inteiro<br>`siglaUf`: Sigla UF ou `BR`<br>`idEleicao`: Inteiro<br>`codigoCargo`: Inteiro (1 a 10) | Listagem oficial de candidatos para cargos federais, estaduais e distritais. Para Presidente e Vice, utiliza-se `siglaUf=BR`. |
| **Candidaturas** | `GET` | `/candidatura/listar/{ano}/{codigoMunicipio}/{idEleicao}/{codigoCargo}/candidatos` | `ano`: Inteiro<br>`codigoMunicipio`: Inteiro<br>`idEleicao`: Inteiro<br>`codigoCargo`: Inteiro (11 a 13) | Listagem oficial de candidatos para pleitos municipais (Prefeito, Vice-Prefeito, Vereador). |
| **Candidaturas** | `GET` | `/candidatura/buscar/{ano}/{siglaUf}/{idEleicao}/candidato/{idCandidato}` | `ano`: Inteiro<br>`siglaUf`: Sigla UF ou `BR`<br>`idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE (int64) | Ficha consolidada contendo qualificacao civil, certidoes, declaracao de bens e historico de candidaturas. |
| **Candidaturas** | `GET` | `/candidatura/buscar/{ano}/{codigoMunicipio}/{idEleicao}/candidato/{idCandidato}` | `ano`: Inteiro<br>`codigoMunicipio`: Inteiro<br>`idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE (int64) | Ficha consolidada de candidato em pleito municipal. |
| **Midias** | `GET` | `/candidatura/buscar/foto/{idEleicao}/{idCandidato}/{versao}` | `idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE<br>`versao`: Inteiro (geralmente 1 ou 2) | Arquivo binario JPEG oficial da fotografia de urna do candidato. |
| **Documentos** | `GET` | `/candidatura/buscar/arquivo/{idEleicao}/{idCandidato}/proposta` | `idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE | Documento original em formato PDF contendo as diretrizes e plano de metas do candidato ao Poder Executivo. |
| **Documentos** | `GET` | `/candidatura/buscar/arquivo/{idEleicao}/{idCandidato}/{idArquivo}` | `idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE<br>`idArquivo`: Inteiro | Documentos complementares (certidoes criminais, comprovantes de desincompatibilizacao). |
| **Prestacao Contas** | `GET` | `/prestador/contas/{idEleicao}/{idCandidato}/dados-gerais` | `idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE | Resumo financeiro: limites legais de gastos do 1º e 2º turnos e volume total de arrecadacao. |
| **Prestacao Contas** | `GET` | `/prestador/contas/{idEleicao}/{idCandidato}/concentracao-despesas` | `idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE | Discriminacao percentual dos maiores tipos de despesas efetuadas na campanha. |
| **Prestacao Contas** | `GET` | `/prestador/contas/{idEleicao}/{idCandidato}/ranking-doadores` | `idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE | Relacao nominal e valores aportados pelos maiores doadores financeiros da candidatura. |

---

## 2. Dicionario de Codigos Oficiais de Cargo do TSE

| Codigo Numerico | Titulo Oficial do Cargo | Ambito Territorial | Indicativo de Chapa / Suplencia |
|---|---|---|---|
| `1` | Presidente | Nacional (`BR`) | Titular (requer Vice - codigo 2) |
| `2` | Vice-Presidente | Nacional (`BR`) | Integrante de chapa majoritaria |
| `3` | Governador | Estadual / Distrital | Titular (requer Vice - codigo 4) |
| `4` | Vice-Governador | Estadual / Distrital | Integrante de chapa majoritaria |
| `5` | Senador | Estadual / Distrital | Titular (requer 1º e 2º suplentes) |
| `6` | Deputado Federal | Estadual / Distrital | Cargo proporcional isolado |
| `7` | Deputado Estadual | Estadual | Cargo proporcional isolado |
| `8` | Deputado Distrital | Distrito Federal | Cargo proporcional isolado |
| `9` | 1º Suplente Senador | Estadual / Distrital | Integrante de chapa de Senador |
| `10` | 2º Suplente Senador | Estadual / Distrital | Integrante de chapa de Senador |
| `11` | Prefeito | Municipal | Titular (requer Vice - codigo 12) |
| `12` | Vice-Prefeito | Municipal | Integrante de chapa municipal |
| `13` | Vereador | Municipal | Cargo proporcional municipal |

---

## 3. Matriz de Mapeamento dos Status de Registro de Candidatura

O campo bruto `descricaoSituacao` retornado pelo TSE apresenta expressiva variacao textual e evolucoes terminologicas ao longo do processo eleitoral. A aplicacao mapeia exaustivamente os valores oficiais para a enum de dominio `RegistrationStatus`:

| Texto Bruto do TSE (`descricaoSituacao`) | Enum da Aplicacao (`RegistrationStatus`) | Significado Juridico e Descricao Explicativa |
|---|---|---|
| `"DEFERIDO"` | `RegistrationStatus.deferred` | Candidatura aprovada regularmente pela Justica Eleitoral com plenas condicoes de elegibilidade. |
| `"DEFERIDO COM RECURSO"` | `RegistrationStatus.deferredWithAppeal` | Candidatura deferida pela Justica Eleitoral, porem alvo de recurso pendente de julgamento em instancia superior. |
| `"AGUARDANDO JULGAMENTO"` | `RegistrationStatus.waitingJudgment` | Pedido de registro submetido, aguardando analise conclusiva do juiz ou tribunal eleitoral. |
| `"INDEFERIDO"` | `RegistrationStatus.ineligible` | Candidatura reprovada pela Justica Eleitoral por descumprimento de condicao legal ou inelegibilidade. |
| `"INDEFERIDO COM RECURSO"` | `RegistrationStatus.ineligibleWithAppeal` | Candidatura indeferida, porem com recurso impetrado pelo candidato em tramitacao em tribunal superior. |
| `"CANCELADO"` | `RegistrationStatus.cancelled` | Registro cancelado em decorrencia de decissao judicial transitada em julgado ou desconvencao partidaria. |
| `"RENÚNCIA"` ou `"RENUNCIA"` | `RegistrationStatus.renunciation` | O proprio candidato manifestou formalmente desistencia da disputa eleitoral perante o juizo competente. |
| `"FALECIDO"` | `RegistrationStatus.deceased` | Candidato falecido no decorrer do processo eleitoral. |
| `"CASSAÇÃO DO REGISTRO"` ou `"CASSADO"` | `RegistrationStatus.revoked` | Registro cassado por sancao imposta em processo de apuracao de ilicito eleitoral. |
| `"SUBSTITUÍDO"` ou `"SUBSTITUIDO"` | `RegistrationStatus.substituted` | Candidatura formalmente substituida por outro filiado indicado pelo partido ou coligacao. |
| `"NÃO CONHECIMENTO DO PEDIDO"` | `RegistrationStatus.unprocessed` | Solicitacao de registro nao apreciada no merito por vicio processual de instrucao. |
| *Qualquer outro texto nao catalogado* | `RegistrationStatus.unknown` | Situacao atipica nao mapeada. O texto original do TSE e preservado para exibicao transparente. |

---

## 4. Entidades Normalizadas em Dart (Camada de Dominio)

O aplicativo desacopla os contratos da Justica Eleitoral das entidades utilizadas pela interface visual:

```dart
/// Identificador de status juridico do registro.
enum RegistrationStatus {
  deferred,
  deferredWithAppeal,
  waitingJudgment,
  ineligible,
  ineligibleWithAppeal,
  cancelled,
  renunciation,
  deceased,
  revoked,
  substituted,
  unprocessed,
  unknown;

  bool get isEligibleToVote =>
      this == RegistrationStatus.deferred ||
      this == RegistrationStatus.deferredWithAppeal ||
      this == RegistrationStatus.waitingJudgment ||
      this == RegistrationStatus.ineligibleWithAppeal;
}

/// Representacao sintetica de candidato para listagens.
class CandidateSummary {
  final int id;
  final int ballotNumber;
  final String ballotName;
  final String fullName;
  final int roleCode;
  final String roleDescription;
  final int partyNumber;
  final String partyAcronym;
  final String partyName;
  final String coalitionName;
  final String coalitionComposition;
  final String photoUrl;
  final RegistrationStatus registrationStatus;
  final String rawStatusDescription;
  final double totalAssetsAmount;

  const CandidateSummary({
    required this.id,
    required this.ballotNumber,
    required this.ballotName,
    required this.fullName,
    required this.roleCode,
    required this.roleDescription,
    required this.partyNumber,
    required this.partyAcronym,
    required this.partyName,
    required this.coalitionName,
    required this.coalitionComposition,
    required this.photoUrl,
    required this.registrationStatus,
    required this.rawStatusDescription,
    required this.totalAssetsAmount,
  });
}

/// Item patrimonial declarado.
class CandidateAsset {
  final int orderIndex;
  final String category;
  final String description;
  final double amount;
  final String updatedAt;

  const CandidateAsset({
    required this.orderIndex,
    required this.category,
    required this.description,
    required this.amount,
    required this.updatedAt,
  });
}

/// Ficha completa e detalhada do candidato.
class CandidateDetail extends CandidateSummary {
  final String birthDate;
  final String gender;
  final String colorRace;
  final String maritalStatus;
  final String educationLevel;
  final String occupation;
  final String nationality;
  final String birthCity;
  final double maxCampaignExpenseFirstTurn;
  final double? maxCampaignExpenseSecondTurn;
  final List<CandidateAsset> assets;
  final List<CandidateSummary> runningMates;
  final String? proposalDocumentUrl;

  const CandidateDetail({
    required super.id,
    required super.ballotNumber,
    required super.ballotName,
    required super.fullName,
    required super.roleCode,
    required super.roleDescription,
    required super.partyNumber,
    required super.partyAcronym,
    required super.partyName,
    required super.coalitionName,
    required super.coalitionComposition,
    required super.photoUrl,
    required super.registrationStatus,
    required super.rawStatusDescription,
    required super.totalAssetsAmount,
    required this.birthDate,
    required this.gender,
    required this.colorRace,
    required this.maritalStatus,
    required this.educationLevel,
    required this.occupation,
    required this.nationality,
    required this.birthCity,
    required this.maxCampaignExpenseFirstTurn,
    this.maxCampaignExpenseSecondTurn,
    required this.assets,
    required this.runningMates,
    this.proposalDocumentUrl,
  });
}
```

---

## 5. Requisitos de Cabecalhos e Emulacao de Borda

Toda requisicao efetuada pelo cliente HTTP `Dio` para os servidores do TSE deve injetar obrigatoriamente os seguintes cabecalhos para evitar rejeicao perimetral:

```http
GET /divulga/rest/v1/candidatura/listar/2026/BR/2045202026/1/candidatos HTTP/1.1
Host: divulgacandcontas.tse.jus.br
User-Agent: Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36
Accept: application/json, text/plain, */*
Accept-Language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7
Referer: https://divulgacandcontas.tse.jus.br/
Origin: https://divulgacandcontas.tse.jus.br
Connection: keep-alive
```
