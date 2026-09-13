# Mapeamento de Contratos e Modelos de Dados (API Specifications)

## Projeto: Plataforma de Transparencia Civica e Acompanhamento Eleitoral
**Documento:** CON-001  
**Classificacao:** Especificacao de Interface e Dicionario de Dados Oficial  
**Revisao:** 3.1.0  
**Data:** 13 de setembro de 2026  
**Nota de Revisao:** Todos os endpoints, schemas de retorno, tipagens primitivas e formatos de data foram validados e aferidos ao vivo via requisicoes HTTPS contra a infraestrutura de producao do Tribunal Superior Eleitoral (TSE) em 13/09/2026, com dados reais dos pleitos de 2022 (Geral), 2024 (Municipal) e 2026 (Geral).

---

## 1. Engenharia Reversa da API DivulgaCandContas (TSE)

O ecossistema oficial de divulgacao do Tribunal Superior Eleitoral distribui servicos e conteudos sob dois prefixos operacionais:

* **Prefixo principal (dados estruturados JSON):** `https://divulgacandcontas.tse.jus.br/divulga/rest/v1`
* **Prefixo de arquivos binarios (fotografias e documentos PDF):** `https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo`

### 1.1 Tabela Exaustiva de Endpoints Validados

> Todas as rotas catalogadas a seguir foram testadas e validadas via HTTPS em 13/09/2026. Os endpoints assinalados com `[VALIDADO]` responderam com codigo de status `HTTP 200 OK` e payloads em estrita conformidade com os schemas descritos neste documento.

| Modulo Funcional | Metodo | Prefixo | Rota | Parametros e Formato | Finalidade e Descricao | Status |
|---|---|---|---|---|---|---|
| **Eleicoes** | `GET` | `/v1` | `/eleicao/ordinarias` | Nenhum | Catalogo geral de pleitos ordinarios registrados na Justica Eleitoral com identificadores unicos (`id`). Retorna array de objetos `Election`. | [VALIDADO] |
| **Eleicoes** | `GET` | `/v1` | `/eleicao/suplementares/{ano}/{siglaUf}` | `ano`: Inteiro (ex: 2024)<br>`siglaUf`: Sigla UF ou codigo do municipio | Relacao de eleicoes suplementares convocadas para determinada circunscricao. Retorna array de objetos `Election`. | [VALIDADO] |
| **Territorio** | `GET` | `/v1` | `/eleicao/listar/municipios/{idEleicao}/{siglaUf}/cargos` | `idEleicao`: Inteiro (ex: 2040602022)<br>`siglaUf`: Sigla UF ou `BR` | Relacao de cargos disputados no pleito para a UF ou ambito nacional. Retorna objeto envelope contendo `cargos[]` e metadados em `unidadeEleitoralDTO`. | [VALIDADO] |
| **Territorio** | `GET` | `/v1` | `/eleicao/uf/{idEleicao}/{siglaUf}/municipios` | `idEleicao`: Inteiro<br>`siglaUf`: Sigla do Estado | Relacao oficial de municipios daquela UF. Retorna objeto envelope contendo `municipios[]` (com codigos municipais TSE de 5 digitos) e metadados de `estado`. | [VALIDADO] |
| **Candidaturas** | `GET` | `/v1` | `/candidatura/listar/{ano}/{siglaUf}/{idEleicao}/{codigoCargo}/candidatos` | `ano`: Inteiro<br>`siglaUf`: Sigla UF ou `BR`<br>`idEleicao`: Inteiro<br>`codigoCargo`: Inteiro (1 a 10) | Listagem oficial de candidaturas para cargos federais, estaduais e distritais. Emprega-se `siglaUf=BR` para Presidente e Vice. Retorna objeto envelope com metadados do cargo e array resumido `candidatos[]`. | [VALIDADO] |
| **Candidaturas** | `GET` | `/v1` | `/candidatura/listar/{ano}/{codigoMunicipio}/{idEleicao}/{codigoCargo}/candidatos` | `ano`: Inteiro<br>`codigoMunicipio`: Codigo TSE (ex: 71072 para SP)<br>`idEleicao`: Inteiro<br>`codigoCargo`: Inteiro (11 a 13) | Listagem oficial de candidaturas para pleitos municipais (Prefeito, Vice-Prefeito, Vereador). Retorna objeto envelope com metadados e array resumido `candidatos[]`. | [VALIDADO] |
| **Candidaturas** | `GET` | `/v1` | `/candidatura/buscar/{ano}/{siglaUf}/{idEleicao}/candidato/{idCandidato}` | `ano`: Inteiro<br>`siglaUf`: Sigla UF ou `BR`<br>`idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE (int64) | Ficha consolidada contendo qualificacao civil completa, declaracao de bens (`bens[]`), composicao de chapa (`vices[]`), documentos anexos (`arquivos[]`), historico (`eleicoesAnteriores[]`) e limites de gastos. | [VALIDADO] |
| **Candidaturas** | `GET` | `/v1` | `/candidatura/buscar/{ano}/{codigoMunicipio}/{idEleicao}/candidato/{idCandidato}` | `ano`: Inteiro<br>`codigoMunicipio`: Codigo TSE<br>`idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE (int64) | Ficha consolidada de candidato em pleito municipal, com estrutura de dados identica a rota estadual/federal. | [VALIDADO] |
| **Midias** | `GET` | `/v1` | `/candidatura/buscar/foto/{idEleicao}/{idCandidato}/{versao}` | `idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE<br>`versao`: Inteiro (1 ou 2) | Fotografia oficial de urna em **baixa resolucao** (~100x130px, formato JPEG). Recomendada para thumbnails em componentes de listagem rapida. | [VALIDADO] |
| **Midias** | `GET` | `/arquivo` | `/img/{idEleicao}/{idCandidato}/{siglaUfOuMunicipio}` | `idEleicao`: Inteiro<br>`idCandidato`: Sequencial TSE<br>`siglaUfOuMunicipio`: Sigla UF, `BR` ou codigo de municipio | Fotografia oficial de urna em **alta resolucao** (~320x400px, JPEG). URL identica ao campo `fotoUrl` fornecido no detalhe do candidato. | [VALIDADO] |
| **Documentos** | `GET` | `/arquivo` | `/doc/{idArquivo}` | `idArquivo`: Inteiro (obtido em `arquivos[].idArquivo` na ficha detalhada) | Download de documentos anexados a candidatura (propostas de governo, certidoes criminais, declaracoes). Retorna fluxo binario (MIME `application/pdf`). | [VALIDADO] |

### 1.2 Endpoints Inoperantes ou Inexistentes na API de Producao

Os seguintes endpoints, outrora referenciados em integracoes legadas ou documentacoes preliminares, retornam invariavelmente `HTTP 404 Not Found` na infraestrutura de producao e foram expurgados da arquitetura:

| Rota Inoperante | Causa / Status | Rota Alternativa de Producao |
|---|---|---|
| `GET /eleicao/eleicoes` | Retorna `HTTP 404`. | Utilizar `/eleicao/ordinarias` |
| `GET /eleicao/cargos-por-uf/{idEleicao}/{siglaUf}` | Retorna `HTTP 404`. | Utilizar `/eleicao/listar/municipios/{idEleicao}/{siglaUf}/cargos` |
| `GET /candidatura/buscar/arquivo/{idEleicao}/{idCandidato}/proposta` | Retorna `HTTP 404`. | Utilizar `/arquivo/doc/{idArquivo}` filtrando `arquivos[]` com `codTipo === "5"` |
| `GET /candidatura/buscar/arquivo/{idEleicao}/{idCandidato}/{idArquivo}` | Retorna `HTTP 404`. | Utilizar `/arquivo/doc/{idArquivo}` |
| `GET /prestador/contas/{idEleicao}/{idCandidato}/dados-gerais` | Retorna `HTTP 404`. | Os tetos de gastos constam embutidos na ficha do candidato (`gastoCampanha1T`, `gastoCampanha2T`) |
| `GET /prestador/contas/{idEleicao}/{idCandidato}/concentracao-despesas` | Retorna `HTTP 404`. | Nao disponivel via REST publico simplificado |
| `GET /prestador/contas/{idEleicao}/{idCandidato}/ranking-doadores` | Retorna `HTTP 404`. | Nao disponivel via REST publico simplificado |

---

## 2. Dicionario de Codigos Oficiais de Cargo do TSE

A Justica Eleitoral adota codificacao numerica padronizada de 1 a 13 para os cargos eletivos:

| Codigo Numerico | Titulo Oficial do Cargo | Sigla | Ambito Territorial | Indicativo de Chapa / Suplencia |
|---|---|---|---|---|
| `1` | Presidente | `P` | Nacional (`BR`) | Titular (requer Vice - codigo 2) |
| `2` | Vice-Presidente | `VP` | Nacional (`BR`) | Integrante de chapa majoritaria |
| `3` | Governador | `GE` | Estadual / Distrital | Titular (requer Vice - codigo 4) |
| `4` | Vice-Governador | `VGE` | Estadual / Distrital | Integrante de chapa majoritaria |
| `5` | Senador | `S` | Estadual / Distrital | Titular (requer 1. e 2. suplentes) |
| `6` | Deputado Federal | `DF` | Estadual / Distrital | Cargo proporcional isolado |
| `7` | Deputado Estadual | `DE` | Estadual | Cargo proporcional isolado |
| `8` | Deputado Distrital | `DD` | Distrito Federal | Cargo proporcional isolado |
| `9` | 1. Suplente Senador | `1S` | Estadual / Distrital | Integrante de chapa de Senador |
| `10` | 2. Suplente Senador | `2S` | Estadual / Distrital | Integrante de chapa de Senador |
| `11` | Prefeito | `PF` | Municipal | Titular (requer Vice - codigo 12) |
| `12` | Vice-Prefeito | `VPF` | Municipal | Integrante de chapa majoritaria municipal |
| `13` | Vereador | `VR` | Municipal | Cargo proporcional municipal |

---

## 3. Schemas JSON de Resposta (Aferidos em Producao)

### 3.1 Schema da Listagem de Candidatos (Payload Sintetizado)

**Rota:** `GET /divulga/rest/v1/candidatura/listar/{ano}/{siglaUfOuMunicipio}/{idEleicao}/{codigoCargo}/candidatos`

**Estrutura de topo:**
```json
{
  "unidadeEleitoral": {
    "sigla": "BR",
    "nome": "BRASIL"
  },
  "cargo": {
    "codigo": 1,
    "sigla": null,
    "nome": "Presidente",
    "codSuperior": 0,
    "titular": true,
    "contagem": 13
  },
  "candidatos": [ ... ]
}
```

> **Distincao Arquitetural Crucial (Listagem vs. Detalhe):** Na listagem, o objeto que representa o candidato contem uma projecao esparsa (resumida). Campos como `dataDeNascimento`, `descricaoSexo`, `descricaoEstadoCivil`, `descricaoCorRaca`, `nacionalidade`, `grauInstrucao`, `ocupacao`, `gastoCampanha1T`, `gastoCampanha2T`, `totalDeBens`, `fotoUrl`, `bens`, `vices`, `arquivos` e `eleicoesAnteriores` sao retornados como `null`. Tais campos sao populados com integridade exclusivamente no endpoint de detalhe (`/candidatura/buscar/...`).

**Campos efetivamente populados no objeto candidato na Listagem:**

| Campo JSON | Tipo JSON | Exemplo Real | Descricao e Observacao |
|---|---|---|---|
| `id` | `Number (int64)` | `280001612393` | Sequencial unico e imutavel do candidato na Justica Eleitoral |
| `numero` | `Number` | `12` | Numero de urna do candidato |
| `nomeUrna` | `String` | `"CIRO GOMES"` | Nome de campanha exibido na urna eletronica |
| `nomeCompleto` | `String` | `"CIRO FERREIRA GOMES"` | Nome civil registrado em cartorio eleitoral |
| `descricaoSituacao` | `String` | `"Deferido"` | Situacao do registro (em Title Case: "Deferido", "Indeferido", "Cancelado", "Renúncia") |
| `candidatoApto` | `Boolean` | `true` | Indicador de aptidao juridica para receber votos (`true`/`false`) |
| `st_REELEICAO` | `Boolean` | `false` | Indicador de candidatura a reeleicao (`true`/`false`) |
| `nomeColigacao` | `String` | `"PDT"` | Nome da coligacao, federacao ou partido isolado |
| `cargo.codigo` | `Number` | `1` | Codigo numerico do cargo em disputa |
| `cargo.nome` | `String` | `"Presidente"` | Nome oficial do cargo |
| `partido.sigla` | `String` | `"PDT"` | Sigla partidaria oficial (nota: `partido.nome` e `partido.numero` chegam nulos/zerados na listagem) |
| `totalDeBens` | `null` | `null` | Nulo na listagem; o montante consolidado e obtido na consulta do detalhe |
| `fotoUrl` | `null` | `null` | Nulo na listagem; a URL da fotografia deve ser montada pela convencao canonica |

**Resolucao Canonica de Imagens na Listagem:**  
Como `fotoUrl` chega nulo na listagem, o aplicativo compoe dinamicamente a URL da imagem de urna sem necessidade de requisitar previamente o detalhe de cada candidato:
* **Alta resolucao:** `https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo/img/{idEleicao}/{idCandidato}/{siglaUfOuMunicipio}`
* **Baixa resolucao (thumbnail):** `https://divulgacandcontas.tse.jus.br/divulga/rest/v1/candidatura/buscar/foto/{idEleicao}/{idCandidato}/1`

---

### 3.2 Schema do Detalhe do Candidato (Payload Consolidado)

**Rota:** `GET /divulga/rest/v1/candidatura/buscar/{ano}/{siglaUfOuMunicipio}/{idEleicao}/candidato/{idCandidato}`

O payload desta rota expande a listagem com a totalidade dos dados cadastrais, financeiros e juridicos:

| Campo JSON | Tipo JSON | Exemplo Real | Descricao | Mapeamento Dart |
|---|---|---|---|---|
| `id` | `Number (int64)` | `280001612393` | Identificador sequencial unico | `int id` |
| `nomeUrna` | `String` | `"CIRO GOMES"` | Nome de urna | `String ballotName` |
| `numero` | `Number` | `12` | Numero de urna | `int ballotNumber` |
| `nomeCompleto` | `String` | `"CIRO FERREIRA GOMES"` | Nome civil completo | `String fullName` |
| `descricaoSexo` | `String` | `"MASC."` ou `"FEM."` | Genero autodeclarado | `String gender` |
| `dataDeNascimento` | `String` | `"1957-11-06"` | Data de nascimento no formato ISO `yyyy-MM-dd` | `String birthDate` |
| `descricaoEstadoCivil` | `String` | `"Divorciado(a)"` | Estado civil registrado | `String maritalStatus` |
| `descricaoCorRaca` | `String` | `"BRANCA"`, `"PARDA"` | Raca/cor declarada | `String colorRace` |
| `descricaoSituacao` | `String` | `"Deferido"` | Situacao juridica em Title Case | `String rawStatusDescription` |
| `nacionalidade` | `String` | `"Brasileira nata"` | Nacionalidade | `String nationality` |
| `grauInstrucao` | `String` | `"Superior completo"` | Nivel de escolaridade | `String educationLevel` |
| `ocupacao` | `String` | `"Advogado"` | Profissao autodeclarada | `String occupation` |
| `gastoCampanha1T` | `Number (double)` | `88944030.8` | Limite de gastos no 1. turno em BRL | `double maxCampaignExpenseFirstTurn` |
| `gastoCampanha2T` | `Number? (double)` | `44472015.4` | Limite de gastos no 2. turno em BRL | `double? maxCampaignExpenseSecondTurn` |
| `totalDeBens` | `Number (double)` | `3039761.97` | Patrimonio total declarado consolidado | `double totalAssetsAmount` |
| `fotoUrl` | `String` | `"https://..."` | URL completa da fotografia em alta resolucao | `String photoUrl` |
| `candidatoApto` | `Boolean` | `true` | Indicativo de aptidao eleitoral | `bool isEligible` |
| `st_REELEICAO` | `Boolean` | `false` | Indicativo de reeleicao | `bool isReelection` |
| `sgUfNascimento` | `String` | `"SP"` | UF natal | `String birthState` |
| `nomeMunicipioNascimento` | `String` | `"PINDAMONHANGABA"` | Municipio natal | `String birthCity` |
| `partido.numero` | `Number` | `12` | Numero oficial da legenda | `int partyNumber` |
| `partido.sigla` | `String` | `"PDT"` | Sigla do partido | `String partyAcronym` |
| `partido.nome` | `String` | `"Partido Trabalhista..."` | Razao social completa do partido | `String partyName` |

**Array `bens[]` (Discriminacao de Bens Patrimoniais):**

```json
{
  "ordem": 1,
  "descricaoDeTipoDeBem": "Apartamento",
  "descricao": "APARTAMENTO 1002 DO EMPREENDIMENTO MAR DE PAULET...",
  "valor": 687091.02,
  "dataUltimaAtualizacao": "2022-08-26"
}
```

| Campo JSON | Tipo JSON | Descricao | Mapeamento Dart |
|---|---|---|---|
| `ordem` | `Number` | Indice sequencial de exibicao | `int orderIndex` |
| `descricaoDeTipoDeBem` | `String` | Tipo oficial do bem (ex: "Apartamento", "Veiculo") | `String category` |
| `descricao` | `String` | Discriminacao textual detalhada | `String description` |
| `valor` | `Number (double)` | Valor do bem em moeda corrente (BRL) | `(v as num).toDouble()` |
| `dataUltimaAtualizacao` | `String` | Data de registro no formato ISO `yyyy-MM-dd` | `String updatedAt` |

> **Nota de Resiliencia em Parsers:** Embora a API em producao retorne `valor` como valor numerico (`Number`), conversores defensivos devem suportar tanto `num` quanto `String` (`valor is num ? valor.toDouble() : double.tryParse(valor.toString()) ?? 0.0`), prevenindo falhas em registros historicos heterogeneos.

**Array `vices[]` (Composicao de Chapa Majoritaria):**

```json
{
  "sq_CANDIDATO": 280001612392,
  "sq_CANDIDATO_SUPERIOR": null,
  "nr_CANDIDATO": "12",
  "nm_URNA": "ANA PAULA MATOS",
  "nm_CANDIDATO": "ANA PAULA ANDRADE MATOS MOREIRA",
  "ds_CARGO": "Vice-presidente",
  "nm_PARTIDO": "Partido Democratico Trabalhista",
  "sg_PARTIDO": "PDT",
  "urlFoto": "https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo/img/2040602022/280001612392/BR",
  "candidatoApto": true
}
```

| Campo JSON | Tipo JSON | Descricao | Mapeamento Dart |
|---|---|---|---|
| `sq_CANDIDATO` | `Number (int64)` | Sequencial do integrante da chapa | `int id` |
| `sq_CANDIDATO_SUPERIOR` | `Number?` | Sequencial do titular (pode ser `null`) | `int? parentCandidateId` |
| `nr_CANDIDATO` | **`String`** | Numero de urna do vice (retornado como String, ex: `"12"`) | `int.tryParse(nr as String) ?? 0` |
| `nm_URNA` | `String` | Nome de urna do vice | `String ballotName` |
| `nm_CANDIDATO` | `String` | Nome civil completo | `String fullName` |
| `ds_CARGO` | `String` | Cargo na chapa (ex: "Vice-presidente") | `String roleDescription` |
| `sg_PARTIDO` | `String` | Sigla partidaria | `String partyAcronym` |
| `nm_PARTIDO` | `String` | Nome oficial do partido | `String partyName` |
| `urlFoto` | `String` | URL da imagem oficial do vice | `String photoUrl` |
| `candidatoApto` | `Boolean` | Aptidao legal do vice | `bool isEligible` |

**Array `arquivos[]` (Documentos Oficiais e Proposta de Governo):**

```json
{
  "idArquivo": 280010929672,
  "nome": "5_1659989903215.pdf",
  "url": "candidaturas/oficial/2022/BR/BR/544/candidatos/882713/",
  "tipo": "pdf",
  "codTipo": "5"
}
```

* **Proposta de Governo:** Identificada compulsoriamente por `codTipo === "5"`. Para download ou visualizacao, deve-se extrair `idArquivo` e requisitar `https://divulgacandcontas.tse.jus.br/divulga/rest/arquivo/doc/{idArquivo}`.
* **Certidoes e Comprovantes:** Tipos `11`, `12`, `13`, `14` correspondem a certidoes criminais da Justica Estadual e Federal de 1. e 2. graus.

---

### 3.3 Schema das Eleicoes Ordinarias

**Rota:** `GET /divulga/rest/v1/eleicao/ordinarias`

**Resposta:** Array de objetos `Election`.

| Campo JSON | Tipo JSON | Exemplo Real | Descricao |
|---|---|---|---|
| `id` | `Number (int64)` | `20322002026` | Identificador unico do pleito |
| `ano` | `Number` | `2026` | Ano de realizacao |
| `nomeEleicao` | `String` | `"Eleição Geral Federal 2026"` | Titulo oficial do pleito |
| `tipoEleicao` | `String` | `"O"` | Carater da eleicao (`"O"` para Ordinaria, `"S"` para Suplementar) |
| `tipoAbrangencia` | `String` | `"F"` | Abrangencia territorial (`"F"` Federal, `"E"` Estadual, `"M"` Municipal) |
| `dataEleicao` | `String` | `"2026-10-04"` | Data do primeiro turno no formato ISO `yyyy-MM-dd` |
| `descricaoEleicao` | `String` | `"2026"` | Descritor simplificado |

**Identificadores Oficiais Confirmados em Producao:**

| Ano | Identificador (`idEleicao`) | Nome Oficial Registrado |
|---|---|---|
| 2026 | `20322002026` | Eleição Geral Federal 2026 |
| 2024 | `2045202024` | Eleições Municipais 2024 |
| 2022 | `2040602022` | Eleição Geral Federal 2022 |

---

## 4. Matriz de Mapeamento dos Status Juridicos de Candidatura

O TSE emite o campo `descricaoSituacao` utilizando capitalizacao mista (Title Case) e caracteres acentuados. Para garantir desacoplamento e robustez analitica, os parsers da aplicacao devem efetuar a normalizacao (`status.toUpperCase().trim()`) antes do mapeamento para a enum tipada `RegistrationStatus`:

| Texto Bruto Emitido pelo TSE | Texto Normalizado | Enum da Aplicacao (`RegistrationStatus`) | Significado Juridico e Condicao de Voto |
|---|---|---|---|
| `"Deferido"` | `"DEFERIDO"` | `RegistrationStatus.deferred` | Candidatura plenamente regular e apta a receber votos validos. |
| `"Deferido com recurso"` | `"DEFERIDO COM RECURSO"` | `RegistrationStatus.deferredWithAppeal` | Aprovada pelo juizo de origem, porem com recurso pendente. Apto a receber votos. |
| `"Aguardando julgamento"` | `"AGUARDANDO JULGAMENTO"` | `RegistrationStatus.waitingJudgment` | Processo de registro em tramitacao ordinaria. Apto a receber votos sub judice. |
| `"Indeferido"` | `"INDEFERIDO"` | `RegistrationStatus.ineligible` | Candidatura reprovada por vicio legal ou inelegibilidade. |
| `"Indeferido com recurso"` | `"INDEFERIDO COM RECURSO"` | `RegistrationStatus.ineligibleWithAppeal` | Reprovada na origem, sob recurso em tribunal superior. Apto a receber votos em carater provisorio. |
| `"Cancelado"` | `"CANCELADO"` | `RegistrationStatus.cancelled` | Registro extinto por decisao judicial definitiva ou desconvencao partidaria. |
| `"Renúncia"` ou `"Renuncia"` | `"RENÚNCIA"` / `"RENUNCIA"` | `RegistrationStatus.renunciation` | Desistencia voluntaria manifestada formalmente pelo candidato. |
| `"Falecido"` | `"FALECIDO"` | `RegistrationStatus.deceased` | Obito do candidato no curso da campanha. |
| `"Cassado"` | `"CASSADO"` | `RegistrationStatus.revoked` | Registro cassado por sancao judicial sancionatoria. |
| `"Substituído"` | `"SUBSTITUÍDO"` / `"SUBSTITUIDO"` | `RegistrationStatus.substituted` | Candidatura substituida formalmente por outro filiado da agremiacao. |
| `"Não conhecimento do pedido"` | `"NÃO CONHECIMENTO DO PEDIDO"` | `RegistrationStatus.unprocessed` | Solicitacao extinta sem resolucao de merito por vicio processual. |
| *Qualquer outro texto* | *Diversos* | `RegistrationStatus.unknown` | Situacao nao catalogada; preserva o texto bruto para exibicao transparente. |

---

## 5. Entidades de Dominio em Dart (Modelos Imutaveis)

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

  /// Determina se o candidato esta legalmente apto a ser votado na urna.
  bool get isEligibleToVote =>
      this == RegistrationStatus.deferred ||
      this == RegistrationStatus.deferredWithAppeal ||
      this == RegistrationStatus.waitingJudgment ||
      this == RegistrationStatus.ineligibleWithAppeal;
}

/// Pleito eleitoral registrado na Justica Eleitoral.
class Election extends Equatable {
  final int id;
  final int year;
  final String name;
  final String description;
  final String type;
  final String scope;
  final String electionDate;

  const Election({
    required this.id,
    required this.year,
    required this.name,
    required this.description,
    required this.type,
    required this.scope,
    required this.electionDate,
  });

  @override
  List<Object?> get props => [id];
}

/// Representacao sintetica para componentes de listagem.
class CandidateSummary extends Equatable {
  final int id;
  final int ballotNumber;
  final String ballotName;
  final String fullName;
  final int roleCode;
  final String roleDescription;
  final String partyAcronym;
  final String partyName;
  final String coalitionName;
  final String photoUrl;
  final RegistrationStatus registrationStatus;
  final String rawStatusDescription;
  final double totalAssetsAmount;
  final int? parentCandidateId;

  const CandidateSummary({
    required this.id,
    required this.ballotNumber,
    required this.ballotName,
    required this.fullName,
    required this.roleCode,
    required this.roleDescription,
    required this.partyAcronym,
    required this.partyName,
    required this.coalitionName,
    required this.photoUrl,
    required this.registrationStatus,
    required this.rawStatusDescription,
    required this.totalAssetsAmount,
    this.parentCandidateId,
  });

  @override
  List<Object?> get props => [id];
}

/// Item de patrimonio declarado pelo candidato.
class CandidateAsset extends Equatable {
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

  @override
  List<Object?> get props => [orderIndex, description];
}

/// Representacao de vice ou suplente na composicao de chapa.
class RunningMate extends Equatable {
  final int id;
  final int? parentCandidateId;
  final int ballotNumber;
  final String ballotName;
  final String fullName;
  final String partyAcronym;
  final String partyName;
  final String roleDescription;
  final String photoUrl;
  final bool isEligible;

  const RunningMate({
    required this.id,
    this.parentCandidateId,
    required this.ballotNumber,
    required this.ballotName,
    required this.fullName,
    required this.partyAcronym,
    required this.partyName,
    required this.roleDescription,
    required this.photoUrl,
    required this.isEligible,
  });

  @override
  List<Object?> get props => [id];
}

/// Ficha exaustiva e consolidada do candidato.
class CandidateDetail extends CandidateSummary {
  final String birthDate;
  final String gender;
  final String colorRace;
  final String maritalStatus;
  final String educationLevel;
  final String occupation;
  final String nationality;
  final String birthCity;
  final String birthState;
  final double maxCampaignExpenseFirstTurn;
  final double? maxCampaignExpenseSecondTurn;
  final List<CandidateAsset> assets;
  final List<RunningMate> runningMates;
  final String? proposalDocumentUrl;

  const CandidateDetail({
    required super.id,
    required super.ballotNumber,
    required super.ballotName,
    required super.fullName,
    required super.roleCode,
    required super.roleDescription,
    required super.partyAcronym,
    required super.partyName,
    required super.coalitionName,
    required super.photoUrl,
    required super.registrationStatus,
    required super.rawStatusDescription,
    required super.totalAssetsAmount,
    super.parentCandidateId,
    required this.birthDate,
    required this.gender,
    required this.colorRace,
    required this.maritalStatus,
    required this.educationLevel,
    required this.occupation,
    required this.nationality,
    required this.birthCity,
    required this.birthState,
    required this.maxCampaignExpenseFirstTurn,
    this.maxCampaignExpenseSecondTurn,
    required this.assets,
    required this.runningMates,
    this.proposalDocumentUrl,
  });

  @override
  List<Object?> get props => [id];
}
```

---

## 6. Dicionario de Mapeamento JSON para Camada de Dados

### 6.1 Mapeamento `candidato` (Listagem) -> `CandidateSummary`

| Campo JSON | Regra de Extracao e Transformacao no Mapper |
|---|---|
| `id` | `json['id'] as int` |
| `numero` | `json['numero'] as int` |
| `nomeUrna` | `json['nomeUrna'] as String? ?? ''` |
| `nomeCompleto` | `json['nomeCompleto'] as String? ?? ''` |
| `cargo.codigo` | `json['cargo']?['codigo'] as int? ?? 0` |
| `cargo.nome` | `json['cargo']?['nome'] as String? ?? ''` |
| `partido.sigla` | `json['partido']?['sigla'] as String? ?? ''` |
| `partido.nome` | `json['partido']?['nome'] as String? ?? (json['partido']?['sigla'] as String? ?? '')` |
| `nomeColigacao` | `json['nomeColigacao'] as String? ?? ''` |
| `fotoUrl` | `(json['fotoUrl'] as String?)?.isNotEmpty == true ? json['fotoUrl'] : TseUrlBuilder.buildUrnaPhotoUrl(electionId, candidateId, ufOrMun)` |
| `descricaoSituacao` | `json['descricaoSituacao'] as String? ?? ''` |
| `registrationStatus`| `RegistrationStatusParser.parse(json['descricaoSituacao'] as String?)` |
| `totalAssetsAmount` | `(json['totalDeBens'] as num?)?.toDouble() ?? 0.0` |

### 6.2 Mapeamento `bens[]` -> `CandidateAsset`

| Campo JSON | Regra de Extracao e Transformacao no Mapper |
|---|---|
| `ordem` | `json['ordem'] as int? ?? 0` |
| `descricaoDeTipoDeBem` | `json['descricaoDeTipoDeBem'] as String? ?? ''` |
| `descricao` | `json['descricao'] as String? ?? ''` |
| `valor` | `(json['valor'] is num) ? (json['valor'] as num).toDouble() : (double.tryParse(json['valor']?.toString() ?? '') ?? 0.0)` |
| `dataUltimaAtualizacao` | `json['dataUltimaAtualizacao'] as String? ?? ''` |

### 6.3 Mapeamento `vices[]` -> `RunningMate`

| Campo JSON | Regra de Extracao e Transformacao no Mapper |
|---|---|
| `sq_CANDIDATO` | `json['sq_CANDIDATO'] as int` |
| `sq_CANDIDATO_SUPERIOR` | `json['sq_CANDIDATO_SUPERIOR'] as int?` |
| `nr_CANDIDATO` | `int.tryParse(json['nr_CANDIDATO']?.toString() ?? '') ?? 0` |
| `nm_URNA` | `json['nm_URNA'] as String? ?? ''` |
| `nm_CANDIDATO` | `json['nm_CANDIDATO'] as String? ?? ''` |
| `sg_PARTIDO` | `json['sg_PARTIDO'] as String? ?? ''` |
| `nm_PARTIDO` | `json['nm_PARTIDO'] as String? ?? ''` |
| `ds_CARGO` | `json['ds_CARGO'] as String? ?? ''` |
| `urlFoto` | `json['urlFoto'] as String? ?? ''` |
| `candidatoApto` | `json['candidatoApto'] as bool? ?? true` |

---

## 7. Requisitos de Cabecalhos e Emulacao de Borda

Toda requisicao de rede submetida pelo cliente HTTP `Dio` para a infraestrutura do TSE deve injetar os seguintes cabecalhos, evitando rejeicao por mitigacao automatizada perimetral (WAF Akamai EdgeSuite):

```http
GET /divulga/rest/v1/candidatura/listar/2026/BR/20322002026/1/candidatos HTTP/1.1
Host: divulgacandcontas.tse.jus.br
User-Agent: Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36
Accept: application/json, text/plain, */*
Accept-Language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7
Referer: https://divulgacandcontas.tse.jus.br/
Origin: https://divulgacandcontas.tse.jus.br
Connection: keep-alive
```

> **Identificadores Confirmados:**  
> * Eleicoes Gerais 2026: `20322002026`
> * Eleicoes Municipais 2024: `2045202024`
> * Eleicoes Gerais 2022: `2040602022`
