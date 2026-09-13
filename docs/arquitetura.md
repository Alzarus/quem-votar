# Arquitetura Tecnica e Mitigacao de Riscos Operacionais

## Projeto: Plataforma de Transparencia Civica e Acompanhamento Eleitoral
**Documento:** ARQ-001  
**Classificacao:** Especificacao Arquitetural e Seguranca de Sistemas  
**Revisao:** 2.1.0  
**Data:** 12 de setembro de 2026  
**Nota de Revisao:** Schema Drift expandido conforme decisoes D03 (tabela unica) e D04 (auto-referencia para vices). Tabela `elections_cargos` adicionada. `idEleicao` 2026 corrigido para `20322002026`.  

---

## 1. Topologia do Sistema: Aplicativo Flutter Standalone

Diferente de sistemas convencionais dependentes de servidores intermediarios proprietarios, a solucao adota uma arquitetura descentralizada de **Aplicativo Multiplataforma Standalone em Flutter**. Todas as capacidades operacionais — comunicacao com a Justica Eleitoral, persistencia relacional, normalizacao de esquemas e gestao de cache — residem no proprio binario do cliente.

```
+-----------------------------------------------------------------------------------+
|                        APLICATIVO FLUTTER (CLIENTE AUTONOMO)                      |
|                                                                                   |
|  +-----------------------------------------------------------------------------+  |
|  | CAMADA DE APRESENTACAO (Presentation Layer)                                 |  |
|  | - Paginas Responsivas (Breakpoints: Compacto, Medio, Expandido)             |  |
|  | - Widgets Acessiveis com Suporte WCAG 2.1 AA (Semantics, 48dp, textScaler)  |  |
|  | - Gerenciamento de Estado Reativo (BLoC / Cubit)                            |  |
|  +---------------------------------------+-------------------------------------+  |
|                                          |                                        |
|                                          v                                        |
|  +-----------------------------------------------------------------------------+  |
|  | CAMADA DE DOMINIO (Domain Layer)                                            |  |
|  | - Entidades Imutaveis de Negocio e Value Objects (CandidateSummary, etc.)   |  |
|  | - Contratos de Repositorios (CandidateRepository, ElectionRepository)       |  |
|  | - Casos de Uso (GetCandidatesUseCase, GetCandidateDetailUseCase)            |  |
|  +---------------------------------------+-------------------------------------+  |
|                                          |                                        |
|                                          v                                        |
|  +-----------------------------------------------------------------------------+  |
|  | CAMADA DE DADOS E PERSISTENCIA LOCAL (Data Layer)                           |  |
|  | - Repositorio de Cache Hibrido Stale-While-Revalidate (SWR)                 |  |
|  | - Banco de Dados Relacional Local: Drift (SQLite) com Streams Reativos      |  |
|  | - Tabela de Metadados de Cache e Hashes SHA-256 (Deteccao de Deltas)        |  |
|  | - Armazenamento de Preferencias Simples: shared_preferences                 |  |
|  +---------------------------------------+-------------------------------------+  |
|                                          |                                        |
|                                          v                                        |
|  +-----------------------------------------------------------------------------+  |
|  | CAMADA DE REDE E CONTENCAO AKAMAI (Network Layer)                           |  |
|  | - Cliente Dio com Interceptor de Cabecalhos Autorizados                     |  |
|  | - Circuit Breaker do Lado do Cliente (Disjuntor de Conexao Local)           |  |
|  | - Limitador de Requisicoes e Mecanismo de Backoff Exponencial com Jitter    |  |
|  +---------------------------------------+-------------------------------------+  |
+------------------------------------------|----------------------------------------+
                                           | HTTPS Direto (dart:io sockets)
                                           | Com emulacao de cabecalhos de borda
                                           v
            +-------------------------------------------------------------+
            | SERVICOS OFICIAIS DO TSE (TRIBUNAL SUPERIOR ELEITORAL)      |
            | - Host: divulgacandcontas.tse.jus.br                        |
            | - Inspecao Perimetral WAF / CDN Akamai EdgeSuite            |
            | - Respostas REST JSON (Candidaturas, Bens, Fotos, Contas)   |
            +-------------------------------------------------------------+
```

---

## 2. Mitigacao de Riscos de Rede e Perimetro Governamental

### 2.1 Contencao do WAF Akamai EdgeSuite
* **Descricao do Problema:** A infraestrutura de divulgacao do TSE e protegida pelo servico de WAF/CDN Akamai EdgeSuite. Requisicoes que nao apresentem cabecalhos tipicos de navegadores legitimos ou que omitam cabeçalhos de contexto de navegacao recebem respostas de erro `HTTP 403 Forbidden` com a mensagem perimetral "Access Denied".
* **Superacao em Ambiente Mobile Nativo:**
  1. Em plataformas mobile nativas (Android e iOS), o motor de conexao do Dart (`dart:io`) opera sobre sockets TCP/TLS diretos, sem a imposicao restritiva de CORS existente nos navegadores web convencionais.
  2. Para evitar o bloqueio automatizado do Akamai, o cliente HTTP (`Dio`) e configurado com um interceptor compulsorio que injeta cabecalhos de navegacao confiaveis em todas as solicitacoes:
     * `User-Agent: Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36`
     * `Accept: application/json, text/plain, */*`
     * `Accept-Language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7`
     * `Referer: https://divulgacandcontas.tse.jus.br/`
     * `Origin: https://divulgacandcontas.tse.jus.br`

### 2.2 Estrategia de Cache Sob Demanda com Deteccao de Deltas
Para evitar a exibicao de dados defasados sem sobrecarregar a infraestrutura governamental, implementa-se um ciclo de vida de dados baseado em **Stale-While-Revalidate (SWR) com Verificacao de Integridade**:

1. **Chave Primaria de Consulta:** `${ano}_${siglaUfOuMunicipio}_${idEleicao}_${codigoCargo}`
2. **Ciclo de Requisicao Sob Demanda:**
   * **Passo 1 (Emissao Imediata):** Ao acionar uma consulta, o repositorio busca os dados na tabela local do Drift (SQLite). Caso existam registros, eles sao emitidos imediatamente para o BLoC, garantindo latencia de renderizacao inferior a 16 milissegundos.
   * **Passo 2 (Avaliacao de Frescor):**
     * Se o registro possuir idade inferior a 60 minutos e nao houver solicitacao explicita do usuario (*pull-to-refresh*), nenhuma requisicao remota e efetuada.
     * Se o registro tiver mais de 60 minutos ou o usuario tiver solicitado atualizacao forcada, o cliente dispara uma chamada condicional em segundo plano com o cabecalho `If-Modified-Since` configurado com o carimbo `lastFetchedAt` da ultima captura valida.
   * **Passo 3 (Deteccao de Atualizacao e Gravacao):**
     * **Resposta `HTTP 304 Not Modified`:** O servidor do TSE confirma que nenhuma mudanca ocorreu. O aplicativo apenas atualiza o carimbo `lastFetchedAt` na tabela de metadados, dispensando regravacoes de banco ou redesenhos de interface.
     * **Resposta `HTTP 200 OK`:** O aplicativo calcula o hash SHA-256 do payload recebido e compara com o `payloadHash` gravado anteriormente.
       * *Hashes Identicos:* Atualiza-se unicamente o `lastFetchedAt`.
       * *Hashes Distintos (Houve Alteracao Oficial):* O aplicativo executa uma transacao atomica no Drift, atualizando os registros de candidatos e bens modificados. Como o Drift opera com streams reativas (`watch()`), a nova lista e transmitida instantaneamente para a interface visual sem trepidacoes (*flickering*).

### 2.3 Disjuntor de Conexao do Lado do Cliente (Circuit Breaker)
Durante o periodo critico de campanha eleitoral, a API do TSE experimenta picos de latencia que excedem 15 segundos ou falhas generalizadas com codigos `HTTP 504 Gateway Timeout` ou `HTTP 502 Bad Gateway`. O aplicativo implementa um disjuntor em memoria no dispositivo:

* **Estado Fechado (Closed):** Operacao normal. Todas as consultas sao repassadas com timeout estrito de 8 segundos.
* **Transicao para Aberto (Open):** Caso ocorram 3 falhas consecutivas de timeout ou erros 5xx dentro de uma janela deslizante de 2 minutos, o circuito abre.
* **Estado Aberto (Open):** Nenhuma requisicao de rede e enviada ao TSE pelos proximos 5 minutos. Todas as consultas sao supridas exclusivamente pelo banco de dados local. A interface exibe um aviso informativo formal: `[MODO CONTINGENCIA LOCAL] Exibindo dados persistidos em [DATA/HORA] devido a instabilidade temporaria no servidor do TSE.`
* **Estado Semi-Aberto (Half-Open):** Apos o periodo de resguardo de 5 minutos, uma requisicao de teste e enviada. Caso seja bem-sucedida, o circuito retorna para o estado Fechado; caso falhe, o circuito reabre por mais 5 minutos.

---

## 3. Modelo de Persistencia Relacional Local (Drift / SQLite)

O banco de dados relacional local garante indexacao rapida, buscas textuais compativeis com acentuacao da lingua portuguesa e suporte a consultas complexas em todo o territorio nacional.

### 3.1 Esquema de Tabelas Principais

```
+------------------------------------------------------------------------------------+
|                             TABELA: elections                                      |
|------------------------------------------------------------------------------------|
| id (INTEGER, PK)        | Identificador no TSE (ex: 20322002026)                    |
| ano (INTEGER)           | Ano do pleito (ex: 2026)                                  |
| nome (TEXT)             | Nome da eleicao (ex: "Eleicao Geral Federal 2026")        |
| descricao (TEXT)        | Descricao oficial completa                                |
| tipo (TEXT)             | "Ordinaria" ou "Suplementar"                              |
| abrangencia (TEXT)      | "F" (Federal), "E" (Estadual) ou "M" (Municipal)          |
| turno (INTEGER)         | Turno do pleito (1 ou 2)                                  |
| data_eleicao (TEXT)     | Data do pleito no formato dd/MM/yyyy                      |
| situacao (TEXT)         | Descricao da situacao da eleicao                          |
+------------------------------------------------------------------------------------+

+------------------------------------------------------------------------------------+
|                          TABELA: elections_cargos                                  |
|------------------------------------------------------------------------------------|
| id (INTEGER, PK, AUTO)  | Identificador sintetico local                             |
| election_id (INTEGER)   | FK -> elections.id                                        |
| state_code (TEXT)       | Sigla UF ou "BR"                                          |
| cargo_code (INTEGER)    | Codigo oficial do cargo (1 a 13)                          |
| cargo_sigla (TEXT)      | Sigla do cargo (ex: "P", "GE", "S")                       |
| cargo_nome (TEXT)       | Nome completo do cargo                                    |
| titular (INTEGER)       | Flag booleano (0 ou 1) indicando se e cargo titular       |
| contagem (INTEGER)      | Total de candidatos registrados para este cargo            |
+------------------------------------------------------------------------------------+

+------------------------------------------------------------------------------------+
|                             TABELA: candidates                                     |
|------------------------------------------------------------------------------------|
| -- Campos de listagem (CandidateSummary) --                                        |
| id (INTEGER, PK)        | Identificador sequencial do candidato no TSE              |
| election_id (INTEGER)   | FK -> elections.id                                        |
| state_code (TEXT)       | Sigla UF ("BA", "SP", "BR", etc.)                         |
| city_code (INTEGER?)    | Codigo TSE do municipio (nulo para cargos estaduais)      |
| role_code (INTEGER)     | Codigo oficial do cargo (1 a 13)                          |
| role_description (TEXT) | Nome completo do cargo                                    |
| ballot_number (INTEGER) | Numero de urna (ex: 4012)                                 |
| ballot_name (TEXT)      | Nome de urna formatado                                    |
| full_name (TEXT)        | Nome completo de registro civil                           |
| party_number (INTEGER)  | Numero da legenda partidaria                              |
| party_acronym (TEXT)    | Sigla do partido (ex: "PSB")                              |
| party_name (TEXT)       | Nome oficial da agremiacao partidaria                     |
| coalition_name (TEXT)   | Nome da coligacao ou federacao partidaria                 |
| coalition_comp (TEXT)   | Composicao partidaria formal                              |
| status (TEXT)           | Status normalizado (ex: "DEFERRED", "INELIGIBLE")         |
| raw_status (TEXT)       | Texto original do TSE (ex: "DEFERIDO COM RECURSO")        |
| total_assets (REAL)     | Total declarado em reais com precisao centesimal          |
| photo_url (TEXT)        | URL oficial da fotografia no TSE (alta resolucao)         |
| local_photo_path (TEXT?)| Caminho do arquivo da foto em cache local no disco        |
| parent_candidate_id (INTEGER?) | FK -> candidates.id (auto-referencia para vices)   |
| -- Campos de detalhe (CandidateDetail) - nullable ate consulta individual --       |
| birth_date (TEXT?)      | Data de nascimento no formato dd/MM/yyyy                  |
| gender (TEXT?)          | Genero declarado (ex: "MASCULINO")                        |
| color_race (TEXT?)      | Autodeclaracao de cor/raca                                |
| marital_status (TEXT?)  | Estado civil (ex: "CASADO(A)")                            |
| education_level (TEXT?) | Grau de instrucao (ex: "SUPERIOR COMPLETO")               |
| occupation (TEXT?)      | Profissao declarada                                       |
| nationality (TEXT?)     | Nacionalidade                                             |
| birth_city (TEXT?)      | Municipio de nascimento                                   |
| birth_state (TEXT?)     | UF de nascimento                                          |
| max_expense_1t (REAL?)  | Limite legal de gastos do 1. turno                        |
| max_expense_2t (REAL?)  | Limite legal de gastos do 2. turno                        |
| proposal_doc_url (TEXT?)| URL da proposta de governo (montada via idArquivo)        |
| campaign_cnpj (TEXT?)   | CNPJ da campanha eleitoral                                |
| detail_fetched (INTEGER)| Flag (0/1) indicando se o detalhe ja foi baixado          |
+------------------------------------------------------------------------------------+

+------------------------------------------------------------------------------------+
|                          TABELA: candidate_assets                                  |
|------------------------------------------------------------------------------------|
| id (INTEGER, PK, AUTO)  | Identificador sintetico local                             |
| candidate_id (INTEGER)  | FK -> candidates.id                                       |
| order_index (INTEGER)   | Ordem de apresentacao informada pelo TSE                  |
| category (TEXT)         | Classificacao (campo `descricaoDeTipoDeBem` do TSE)       |
| description (TEXT)      | Descricao discriminada do item                            |
| amount (REAL)           | Valor venal declarado (convertido de String no JSON)      |
| updated_at (TEXT)       | Data de atualizacao no sistema eleitoral                  |
+------------------------------------------------------------------------------------+

+------------------------------------------------------------------------------------+
|                          TABELA: cache_metadata                                    |
|------------------------------------------------------------------------------------|
| cache_key (TEXT, PK)    | Chave concatenada: {ano}_{uf}_{idEleicao}_{codigoCargo}  |
| last_fetched_at (TEXT)  | Carimbo ISO-8601 da ultima comunicacao valida             |
| payload_hash (TEXT)     | Hash SHA-256 do corpo de resposta                         |
| etag (TEXT?)            | Valor de ETag fornecido pelo servidor governamental       |
| item_count (INTEGER)    | Total de registros retornados na consulta                 |
+------------------------------------------------------------------------------------+
```

### 3.2 Estrategia de Indices de Performance
Para assegurar tempos de recuperacao inferiores a 50 milissegundos mesmo com dezenas de milhares de registros no dispositivo, sao instanciados os seguintes indices no SQLite:

1. `idx_candidates_query`: Indice composto sobre `(election_id, state_code, role_code)`.
2. `idx_candidates_party`: Indice sobre `(election_id, party_number)`.
3. `idx_candidates_search`: Indice textual sobre `(ballot_name, full_name, ballot_number)`.
4. `idx_assets_candidate`: Indice sobre `(candidate_id, amount DESC)`.
5. `idx_candidates_parent`: Indice sobre `(parent_candidate_id)` para consulta de vices/suplentes.
6. `idx_cargos_query`: Indice composto sobre `(election_id, state_code)` na tabela `elections_cargos`.

---

## 4. Gestao e Cache de Midias (Fotografias Oficiais)

As fotografias de campanha representam o principal volume de transferencia de dados. O aplicativo gerencia esse fluxo defensivamente:

1. **Requisicao com Cabecalhos Akamai:** Requisicoes para download de fotos utilizam o cliente Dio com injecao automatica do cabecalho `Referer: https://divulgacandcontas.tse.jus.br/`, impedindo que o WAF bloqueie o acesso a imagem.
2. **Armazenamento Permanente em Disco:** As fotos sao gravadas no diretorio de cache do aplicativo no sistema de arquivos do dispositivo (`getTemporaryDirectory()` / `getApplicationSupportDirectory()`).
3. **Tratamento de Falhas e Imagem Padrao:** Caso o candidato nao tenha foto registrada ou o arquivo esteja corrompido, o aplicativo renderiza instantaneamente uma silhueta vetorial neutra institucional, informando de maneira acessivel a indisponibilidade de imagem oficial.
