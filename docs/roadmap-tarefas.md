# Estrutura Analitica de Projeto e Roadmap de Implementacao (WBS)

## Projeto: Plataforma de Transparencia Civica e Acompanhamento Eleitoral
**Documento:** WBS-001  
**Classificacao:** Plano Operacional, Rastreabilidade e Gestao de Tarefas  
**Revisao:** 1.1.0  
**Data:** 15 de setembro de 2026  
**Status de Referencia:** [PENDENTE] Nao iniciado | [EM PROGRESSO] Em execucao | [CONCLUIDO] Validado no Harness  

---

## 1. Visao Metodologica do Roadmap

Este documento formaliza a divisao do trabalho de engenharia de software para o desenvolvimento integral do aplicativo civico *Quem Votar*. A estruturacao segue as treze diretrizes compulsórias de Clean Code para agentes de inteligencia artificial e engenharia disciplinada descritas em [COD-001](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/docs/convencoes-codigo.md) e [AGENTS.md](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/AGENTS.md).

Toda tarefa deve:
1. Conter escopo delimitado, previsivel e testavel de forma isolada (*Headless F.I.R.S.T*).
2. Manter arquivos abaixo de 300 linhas de codigo e funcoes com no maximo 20 linhas.
3. Ser validada obrigatoriamente pelos comandos do harness no PowerShell:
   * `flutter test --no-pub --coverage`
   * `flutter analyze`
   * `dart format --line-length 100 .`

---

## 2. Matriz de Tarefas por Fases

```
+---------------------------------------------------------------------------------------+
| FASE 0: BOOTSTRAP E INFRAESTRUTURA DE TESTES                                          |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T0.1   | Inicializacao do projeto Flutter 3.41+ multiplataforma      | [CONCLUIDO]    |
| T0.2   | Configuracao de dependencias em pubspec.yaml                | [CONCLUIDO]    |
| T0.3   | Configuracao de linter estrito em analysis_options.yaml     | [CONCLUIDO]    |
| T0.4   | Criacao da arvore canonica de diretorios (lib/ e test/)     | [CONCLUIDO]    |
| T0.5   | Extracao e catalogacao das fixtures JSON em test/fixtures/  | [CONCLUIDO]    |
+--------+-------------------------------------------------------------+----------------+

+---------------------------------------------------------------------------------------+
| FASE 1: NUCLEO (CORE LAYER), REDE E RESILIENCIA                                       |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T1.1   | Tipos Result<T, Failure> e excecoes contextuais de erro     | [CONCLUIDO]    |
| T1.2   | Cliente HTTP Dio com suporte a Akamai e base relativa Web   | [CONCLUIDO]    |
| T1.3   | Circuit Breaker em memoria de tres estados (Closed/Open/Half)| [CONCLUIDO]    |
| T1.4   | Testes unitarios headless de rede e Circuit Breaker         | [CONCLUIDO]    |
+--------+-------------------------------------------------------------+----------------+

+---------------------------------------------------------------------------------------+
| FASE 2: PERSISTENCIA RELACIONAL LOCAL (DRIFT / SQLITE)                                |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T2.1   | Definicao dos schemas das tabelas Drift (5 tabelas)         | [CONCLUIDO]    |
| T2.2   | Declaracao dos 6 indices de performance SQLite              | [CONCLUIDO]    |
| T2.3   | Conexao multiplataforma (Drift Native vs Drift WASM)        | [CONCLUIDO]    |
| T2.4   | Execucao do build_runner e geracao do AppDatabase           | [CONCLUIDO]    |
| T2.5   | Testes unitarios headless com SQLite em memoria             | [CONCLUIDO]    |
+--------+-------------------------------------------------------------+----------------+

+---------------------------------------------------------------------------------------+
| FASE 3: CAMADA DE DOMINIO (DOMAIN LAYER)                                              |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T3.1   | Entidades puras e imutaveis (CandidateSummary, Detail, etc.)| [CONCLUIDO]    |
| T3.2   | Enums e Value Objects tipados (CandidateStatus, Gender, etc)| [CONCLUIDO]    |
| T3.3   | Contratos abstratos de repositorios                         | [CONCLUIDO]    |
| T3.4   | Casos de uso (GetCandidatesList, GetCandidateDetail, etc.)  | [CONCLUIDO]    |
| T3.5   | Testes unitarios dos casos de uso com fakes nomeados        | [CONCLUIDO]    |
+--------+-------------------------------------------------------------+----------------+

+---------------------------------------------------------------------------------------+
| FASE 4: CAMADA DE DADOS E CACHE SWR (DATA LAYER)                                      |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T4.1   | DTOs e Mappers defensivos com parsing estrito de nulos      | [CONCLUIDO]    |
| T4.2   | TseRemoteDataSource com decodificacao de envelopes TSE      | [CONCLUIDO]    |
| T4.3   | CandidateLocalDataSource com operacoes de DAOs do Drift     | [CONCLUIDO]    |
| T4.4   | CandidateRepositoryImpl com politica SWR e hash SHA-256     | [CONCLUIDO]    |
| T4.5   | Testes unitarios de mappers e do ciclo SWR com fixtures     | [CONCLUIDO]    |
+--------+-------------------------------------------------------------+----------------+

+---------------------------------------------------------------------------------------+
| FASE 5: DESIGN SYSTEM E COMPONENTES ACESSIVEIS (PRESENTATION CORE)                    |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T5.1   | Tokens semanticos de cor (HSL) e temas Claro/Escuro         | [CONCLUIDO]    |
| T5.2   | Escala tipografica acessivel com textScaler dinamico        | [CONCLUIDO]    |
| T5.3   | Componentes atomicos acessiveis (Avatar, Badge, Chips, Card)| [CONCLUIDO]    |
| T5.4   | Testes de widget e verificacao WCAG (alvos 48dp e Semantics)| [CONCLUIDO]    |
+--------+-------------------------------------------------------------+----------------+

+---------------------------------------------------------------------------------------+
| FASE 6: GERENCIAMENTO DE ESTADO E TELAS (PRESENTATION LAYER)                          |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T6.1   | BLoC de Selecao de Eleicao, UF e Cargo (Padrao: 2026/BR)    | [CONCLUIDO]    |
| T6.2   | BLoC de Listagem de Candidatos com busca textual e debounce | [CONCLUIDO]    |
| T6.3   | BLoC de Detalhes do Candidato e Auditoria Patrimonial       | [CONCLUIDO]    |
| T6.4   | Pagina responsiva CandidateListPage (1, 2 e 3 colunas)      | [CONCLUIDO]    |
| T6.5   | Pagina de detalhes CandidateDetailPage                     | [CONCLUIDO]    |
| T6.6   | Testes de integracao de fluxo de tela                       | [CONCLUIDO]    |
+--------+-------------------------------------------------------------+----------------+

+---------------------------------------------------------------------------------------+
| FASE 7: INFRAESTRUTURA DE BORDA, DEPLOY E VALIDACAO EM PRODUCAO                       |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T7.1   | Estruturacao de /opt/quemvotar e Docker Compose na VM       | [CONCLUIDO]    |
| T7.2   | Configuracao do Nginx Alpine com Micro-Proxy de Cache TSE   | [CONCLUIDO]    |
| T7.3   | Configuracao do Proxy Host e SSL no Nginx Proxy Manager     | [CONCLUIDO]    |
| T7.4   | Build de producao web e deploy automatizado via SCP         | [CONCLUIDO]    |
| T7.5   | Validacao de operacao offline (PWA) e auditoria de cache    | [CONCLUIDO]    |
+--------+-------------------------------------------------------------+----------------+

+---------------------------------------------------------------------------------------+
| FASE 8: OTIMIZACAO WEB, REDUCAO DE JORNADA E FILTROS MULTICRITERIO (UI/UX PRO)        |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T8.1   | Preloader nativo HTML/CSS em web/index.html e PWA meta tags | [CONCLUIDO]    |
| T8.2   | Expansao do CandidateListState e BLoC com filtros status/bens| [CONCLUIDO]    |
| T8.3   | Componentes CandidateRoleSelectorPills, FilterSheet e Bar   | [CONCLUIDO]    |
| T8.4   | UrlLauncherService, remocao de dropdown e novo icone filtro | [CONCLUIDO]    |
| T8.5   | Hardening de infraestrutura e criacao da skill de seguranca | [CONCLUIDO]    |
+--------+-------------------------------------------------------------+----------------+
```

---

## 3. Detalhamento Operacional das Tarefas

### Fase 0: Bootstrap e Infraestrutura de Testes

#### `[T0.1]` Inicializacao do Projeto Flutter
* **Objetivo:** Criar o projeto Flutter no diretorio raiz com identificador de organizacao compativel e plataformas multiplataforma ativas (`web`, `android`, `windows`).
* **Comando:** `flutter create --org br.org.todeolho --project-name quem_votar --platforms=web,android,windows .`
* **Criterio de Aceite:** O projeto compila com sucesso e preserva os arquivos preexistentes de governanca e documentacao.

#### `[T0.2]` Configuracao de Dependencias (`pubspec.yaml`)
* **Objetivo:** Adicionar pacotes oficiais de producao e ferramentas de geracao de codigo:
  * Producao: `dio`, `drift`, `sqlite3_flutter_libs`, `flutter_bloc`, `path_provider`, `intl`, `equatable`, `crypto`.
  * Desenvolvimento: `build_runner`, `drift_dev`, `mocktail`, `bloc_test`, `flutter_lints`.
* **Criterio de Aceite:** `flutter pub get` executa sem conflitos de versao de dependencias.

#### `[T0.3]` Configuracao do Linter Oficial (`analysis_options.yaml`)
* **Objetivo:** Ativar regras estritas de qualidade alinhadas as 13 diretrizes de Clean Code: proibicao de `avoid_dynamic_calls`, `unawaited_futures`, `prefer_const_constructors`, `always_declare_return_types`.
* **Criterio de Aceite:** `flutter analyze` executa sem alertas em arquivos limpos.

#### `[T0.4]` Estrutura Canonica de Pastas
* **Objetivo:** Criar os subdiretorios conforme a arquitetura estrita:
  * `lib/core/{network,errors,utils}/`
  * `lib/domain/{entities,repositories,usecases}/`
  * `lib/data/{datasources,models,mappers,repositories,database}/`
  * `lib/presentation/{blocs,pages,widgets,theme}/`
  * `test/{unit,widget,fixtures}/`
* **Criterio de Aceite:** Diretorios criados e prontos para insercao de codigo modular.

#### `[T0.5]` Catalogo de Fixtures de Teste (`test/fixtures/`)
* **Objetivo:** Criar arquivos JSON reais extraidos dos contratos testados em [CON-001](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/docs/api-contracts.md):
  * `test/fixtures/eleicoes_ordinarias.json`
  * `test/fixtures/cargos_br_2026.json`
  * `test/fixtures/candidatos_presidente_2026.json`
  * `test/fixtures/candidato_detalhe_completo.json`
* **Criterio de Aceite:** Fixtures carregaveis via helper em testes unitarios headless sem internet.

---

### Fase 1: Nucleo (Core Layer), Rede e Resiliencia

#### `[T1.1]` Abstracoes de Retorno e Falhas
* **Objetivo:** Implementar o tipo imutavel `Result<T, Failure>` e classes de erro com contexto rico: `ServerFailure`, `CacheFailure`, `NetworkFailure`.
* **Criterio de Aceite:** Testes comprovando isolamento de excecoes e fluxo plano de retorno sem `try/catch` vazando para o dominio.

#### `[T1.2]` Cliente HTTP Dio com Interceptor Akamai
* **Objetivo:** Criar fabrica de cliente HTTP com configuracao condicional:
  * Em plataforma Web: Utiliza URL relativa `/quemvotar/api/`.
  * Em plataforma Mobile/Desktop: Injeta cabeçalhos perimetrais do Akamai (`User-Agent`, `Referer`, `Origin`).
* **Criterio de Aceite:** Requisicoes locais mockadas validam presenca dos cabecalhos corretos.

#### `[T1.3]` Circuit Breaker do Lado do Cliente
* **Objetivo:** Implementar disjuntor em memoria de tres estados (`Closed`, `Open`, `Half-Open`) com contagem de falhas consecutivas e janela de resguardo de 5 minutos.
* **Criterio de Aceite:** Teste unitario simulando 3 falhas consecutivas e confirmando abertura do circuito e contingencia local.

---

### Fase 2: Persistencia Relacional Local (Drift / SQLite)

#### `[T2.1] e [T2.2]` Schemas das Tabelas e Indices
* **Objetivo:** Definir as tabelas `ElectionsTable`, `ElectionsCargosTable`, `CandidatesTable`, `CandidateAssetsTable` e `CacheMetadataTable` com indices de performance no Drift.
* **Criterio de Aceite:** Codigo gerado pelo `build_runner` sem erros.

#### `[T2.3] e [T2.4]` Conexao Multiplataforma e Geracao de Codigo
* **Objetivo:** Implementar fabrica condicional de conexao (`database_connection_native.dart` e `database_connection_web.dart` com WASM).
* **Criterio de Aceite:** Compilacao bem-sucedida em Windows e Web.

#### `[T2.5]` Testes Headless do Banco de Dados
* **Objetivo:** Executar testes unitarios utilizando o executor em memoria `drift/native.dart`.
* **Criterio de Aceite:** 100% de cobertura nas operacoes CRUD e queries relacionais.

---

### Fase 3: Camada de Dominio (Domain Layer)

#### `[T3.1] e [T3.2]` Entidades e Value Objects
* **Objetivo:** Criar classes de dominio imutaveis e puras sem referencias a pacotes de banco ou rede: `CandidateSummary`, `CandidateDetail`, `CandidateAsset`, `Election`.
* **Criterio de Aceite:** Classes com `operator ==` e `hashCode` consistentes.

#### `[T3.3] e [T3.4]` Interfaces de Repositorio e Casos de Uso
* **Objetivo:** Definir contratos abstratos e implementar casos de uso com responsabilidade unica:
  * `GetElectionsUseCase`
  * `GetCandidatesListUseCase`
  * `GetCandidateDetailUseCase`
* **Criterio de Aceite:** Casos de uso validados por testes unitarios com `mocktail`.

---

### Fase 4: Camada de Dados e Cache SWR (Data Layer)

#### `[T4.1] a [T4.4]` Mappers, Fontes de Dados e Repositorio SWR
* **Objetivo:** Implementar o fluxo completo de dados: conversao de DTOs do TSE, persistencia atomica no SQLite e comparacao de integridade com hash SHA-256.
* **Criterio de Aceite:** Ciclo SWR emite dados do banco imediatamente e dispara atualizacao assincrona em segundo plano.

---

### Fase 5: Design System e Componentes Acessiveis

#### `[T5.1] a [T5.4]` Tokens Visuais e Componentes Acessiveis
* **Objetivo:** Criar o tema institucional conforme [docs/design-system.md](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/docs/design-system.md) e skill `ui-ux-pro`:
  * Paleta de cores com contraste certificado de 4,5:1.
  * Alvos de toque minimos de 48x48dp.
  * Anotacoes `Semantics` em todos os elementos informativos.
* **Criterio de Aceite:** Testes de widget verificando acessibilidade visual e estrutural.

---

### Fase 6: Gerenciamento de Estado e Telas

#### `[T6.1] a [T6.6]` BLoCs e Paginas Responsivas
* **Objetivo:** Construir as telas `CandidateListPage` e `CandidateDetailPage` integradas aos respectivos BLoCs, exibindo inicialmente o pleito federal de 2026.
* **Criterio de Aceite:** Fluxos completos de busca textual, selecao de UF e visualizacao de bens em grelha responsiva funcional.

---

### Fase 7: Infraestrutura, Deploy e Validacao

#### `[T7.1] a [T7.5]` Configuracao da VM e Deploy de Producao
* **Objetivo:** Criar o container `/opt/quemvotar`, configurar o Nginx Proxy Manager com SSL e validar o micro-proxy de cache em producao.
* **Criterio de Aceite:** Aplicacao disponivel publicamente em `https://todeolho.org/quemvotar` com tempo de resposta do cache inferior a 2ms.

---

### Fase 8: Otimizacao de Performance Web, Reducao de Jornada e Filtros Multicriterio (UI/UX Pro)

#### `[T8.1]` Preloader Nativo em HTML/CSS e Meta Tags Semanticas
* **Objetivo:** Inserir preloader leve (< 3 KB) na paleta civica (#1E40AF) no `web/index.html` com suporte a modo escuro e transicao em `flutter-first-frame`, eliminando a tela branca inicial.
* **Criterio de Aceite:** Carga visual em menos de 100ms e transicao suave para a aplicacao Flutter.

#### `[T8.2]` Expansao de Estado no CandidateListBloc e Filtros Multicriterio
* **Objetivo:** Implementar os enums `CandidateStatusFilter` e `CandidateAssetsFilter`, conectando-os ao pipeline linear O(N) do BLoC com testes unitarios headless cobrindo combinacoes e limpeza de filtros.
* **Criterio de Aceite:** 100% de cobertura nos testes unitarios do BLoC com filtros combinados.

#### `[T8.3]` Componentes de Alta Densidade e Ergonomia (WCAG 2.1 AA)
* **Objetivo:** Implementar `CandidateRoleSelectorPills` (alternancia de cargos em 1 toque), `CandidateFilterBottomSheet` (modal ergonômico) e `CandidateActiveFilterBar` (chips com remocao individual).
* **Criterio de Aceite:** Alvos de toque >= 48dp, anotacoes `Semantics` completas e retencao de rolagem via `PageStorageKey`.

#### `[T8.4]` Integracao de UrlLauncherService, Remocao de Dropdown e Novo Icone de Filtro
* **Objetivo:** Implementar o servico multiplataforma `UrlLauncherService` desacoplado para abertura de propostas de governo (PDF), conectar fallback em `CandidateDetailPage`, remover a duplicidade de dropdown de cargos no `CandidateFilterToolbar` (preservando `CandidateRoleSelectorPills`) e atualizar o icone do botao de filtros para `Icons.filter_alt_outlined` com tooltip.
* **Criterio de Aceite:** 100% de cobertura nos testes de unidade e widget, acionamento do launcher validado sem erros e harness aprovado.

#### `[T8.5]` Streaming HTTP no Micro-Proxy e Skill de Hardening de Seguranca
* **Objetivo:** Otimizar o micro-proxy Node.js (`proxy.mjs`) com streaming assincrono (`Readable.fromWeb`) para prevenir saturacao de memoria RAM no download concorrente de PDFs e criar a skill `.agents/skills/security-hardening` com padroes de DevSecOps, Nginx hardening, seguranca em Docker/VM e conformidade LGPD.
* **Criterio de Aceite:** Streaming operando sem buffers inteiros em memoria e arquivo `SKILL.md` homologado.

---

## 4. Backlog de Aprimoramentos e Refinamentos (A Fazer Depois)

| Codigo | Item de Refinamento / Demanda Registrada | Escopo Tecnico e Solucao Planejada | Status |
|---|---|---|---|
| **B.1** | Correcao definitiva da exibicao do icone do botao de filtros no Web | Investigar o tree-shaking de fontes de icones no Flutter Web (`--no-tree-shake-icons`) e refatorar `OutlinedButton` para `IconButton.outlined` ou glifo SVG estatico | [CONCLUIDO] |
| **B.2** | Hardening defensivo de Nginx e Rate Limiting na VM Contabo | Adicionar cabecalhos `X-Frame-Options: SAMEORIGIN`, `X-Content-Type-Options: nosniff` e diretiva `limit_req_zone` no `nginx.conf` da VM | [CONCLUIDO] |
| **B.3** | Harmonizacao do Design System com o portal institucional To de Olho | Mapear a paleta de cores e tipografia de `to-de-olho` para os tokens `AppColors` e `AppTypography`, mantendo a identidade visual unificada | [PENDENTE] |
| **B.4** | Substituicao de icones PWA, splash e eliminacao do logotipo Flutter | Substituir `web/favicon.png`, icones em `web/icons/` e splash do PWA pelo isotipo do projeto, removendo assets do Flutter no boot e visualizador | [CONCLUIDO] |
| **B.5** | Seletor de Ano e Pleito Eleitoral Historico na interface | Expor o seletor de Ano/Pleito (2026, 2024, 2022...) na interface, aproveitando o suporte que o BLoC e a API do TSE ja possuem nativamente | [CONCLUIDO] |
| **B.6** | Indicador visual assertivo de filtros ativos (badge e destaque) | Adicionar indicador numerico (badge) no botao de filtros e destacar escolhas ativas no modal e na barra superior | [CONCLUIDO] |
| **B.7** | Navegacao resiliente no PWA e botao explicito de fechar propostas | Prevenir fechamento indevido do PWA ao voltar da proposta de governo, incorporando botao de encerramento e controle de historico com PopScope | [CONCLUIDO] |
| **B.8** | Reavaliacao ergonomica do botao de atualizacao (Pull-to-Refresh) | Auditar a redundancia do botao fixo de atualizacao na AppBar, substituindo-o por Pull-to-Refresh na listagem | [CONCLUIDO] |
| **B.9** | Alternancia explicita de temas (Claro/Escuro) e persistencia | Implementar seletor acessivel de tema na interface com persistencia local da preferencia (Claro, Escuro, Sistema) | [CONCLUIDO] |
| **B.10** | Filtragem multipartidaria simultanea (multi-select de partidos) | Expandir o BLoC e o modal para permitir a selecao concomitante de multiplas legendas partidarias | [CONCLUIDO] |
| **B.11** | Modulo comparador analitico direto entre candidaturas | Desenvolver tela dedicada para contrastar lado a lado patrimonio, propostas, limites de gastos e registros de 2 a 3 candidatos | [PENDENTE] |
| **B.12** | Adequacao de metadados de instalacao do PWA (manifest e titulo) | Ajustar manifest.json e index.html com o nome oficial "Quem Votar" (eliminando o identificador tecnico quem_votar) e descricao formal | [CONCLUIDO] |

---

### 4.1 Detalhamento Tecnico dos Itens de Refinamento e Usabilidade

#### `[B.2]` Hardening Defensivo de Nginx e Rate Limiting na VM de Borda
* **Contexto e Problema:** Necessidade de mitigar ataques volumetricos, Clickjacking, MIME-sniffing e scraping abusivo contra o micro-proxy do TSE em ambiente de producao.
* **Solucao de Engenharia:**
  1. Configurar `limit_req_zone $binary_remote_addr zone=api_limit:10m rate=30r/s;` no escopo HTTP em [deploy/nginx.conf](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/deploy/nginx.conf).
  2. Aplicar `limit_req zone=api_limit burst=50 nodelay;` e `limit_req_status 429;` nos endpoints `/quemvotar/api/` e `/quemvotar/api/arquivo/`.
  3. Desativar versao do servidor com `server_tokens off;`.
  4. Injetar cabecalhos defensivos: `X-Frame-Options: SAMEORIGIN`, `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`, `Permissions-Policy` e `Strict-Transport-Security`.
* **Criterios de Aceite:** Servidor Nginx protegido contra estouro de requisicoes com resposta 429 e cabecalhos de seguranca ativos em todas as respostas HTTP.

#### `[B.5]` Seletor de Ano e Pleito Eleitoral Historico na Interface
* **Contexto e Problema:** A aplicacao possuia suporte nativo no BLoC e na API do TSE para carregar diferentes pleitos (2026, 2024, 2022...), mas a interface nao disponibilizava o dropdown correspondente ao usuario na barra de ferramentas.
* **Solucao de Engenharia:**
  1. Expandir [CandidateFilterToolbar](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/widgets/candidate_filter_toolbar.dart) com os parametros `availableElections`, `selectedElection` e callback `onElectionChanged`.
  2. Implementar leiaute adaptativo: em telas amplas, dispor Pleito, Territorio e Ordenacao em linha; em telas compactas, organizar Pleito e Territorio na primeira linha e Ordenacao na segunda linha com alvos minimos de toque de 48dp.
  3. Conectar a selecao em [CandidateListPage](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/pages/candidate_list_page.dart) despachando `ElectionFilterElectionChanged` para o BLoC correspondente.
  4. Cobrir com testes de widget e de fluxo de tela.
* **Criterios de Aceite:** Eleitor consegue alternar entre pleitos historicos com atualizacao automatica da listagem de candidatos e conformidade WCAG 2.1 AA.

#### `[B.4]` Substituicao Integral de Icones PWA, Splash Screen e Logotipo Padrao do Flutter
* **Contexto e Problema:** Ao executar a aplicacao web ou instala-la como Progressive Web App (PWA), o icone padrao do framework Flutter e exibido na inicializacao (splash), no cabecalho da janela e ao abrir visualizadores de documentos (propostas de governo).
* **Solucao de Engenharia:**
  1. Gerar e substituir o conjunto de icones em [web/icons/](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/web/icons) (`Icon-192.png`, `Icon-512.png`, `Icon-maskable-192.png`, `Icon-maskable-512.png`) e [web/favicon.png](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/web/favicon.png) com os assets oficiais do projeto civico.
  2. Ajustar os marcadores `<link rel="apple-touch-icon">` e `<link rel="icon">` em [web/index.html](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/web/index.html).
  3. Revisar o visualizador de documentos para evitar o disparo de fallbacks que renderizem o icone generico da engine.
* **Criterios de Aceite:** Ausencia completa de simbolos ou graficos padrao do Flutter durante a inicializacao, navegacao e inspecao de metadados do PWA.

#### `[B.6]` Indicador Visual Assertivo de Filtros Ativos (Badge Numerico e Destaque)
* **Contexto e Problema:** Ao selecionar parametros no modal de filtros ([CandidateFilterBottomSheet](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/widgets/candidate_filter_bottom_sheet.dart)), a interface principal nao evidencia de forma destacada e imediata a aplicacao dos filtros, dificultando a compreensao do eleitor sobre quais restricoes estao ativas.
* **Solucao de Engenharia:**
  1. Adicionar contador numerico contextual (*badge* sobreposto) no botao de filtros em [CandidateListPage](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/pages/candidate_list_page.dart), exibindo a quantidade total de criterios customizados aplicados.
  2. Reforcar os estados visuais selecionados dentro do modal (`ChoiceChip` com marcadores de selecao `Icons.check`, cor de fundo tonal e borda de alto contraste).
  3. Garantir sincronizacao dinamica com [CandidateActiveFilterBar](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/widgets/candidate_active_filter_bar.dart) para exibicao imediata dos chips removiveis no topo da listagem.
* **Criterios de Aceite:** Contraste minimo de 4,5:1 (WCAG 2.1 AA), visibilidade imediata da contagem de filtros na barra de ferramentas e suporte a rotulagem semantica para leitores de tela.

#### `[B.7]` Navegacao Resiliente no PWA e Botao Explicito de Fechar Propostas
* **Contexto e Problema:** No modo PWA em dispositivos moveis (janela *standalone*), ao acessar o documento PDF da proposta de governo por meio do servico [UrlLauncherService](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/core/network/url_launcher_service.dart), a utilizacao do gesto ou botao "voltar" nativo do sistema operacional provoca o encerramento da aplicacao em vez de retornar a ficha do candidato.
* **Solucao de Engenharia:**
  1. Implementar interceptacao defensiva de rotas via `PopScope` no Flutter para navegacao na web/PWA.
  2. Disponibilizar modal interno acessivel ou visualizador com barra superior contendo botao de fechamento explicito (*Close/Voltar* com `Icons.close`), mantendo o historico do navegador isolado da janela principal da aplicacao.
  3. No caso de abertura externa, utilizar configuracao segura que previna o descarte da sessao PWA ativa.
* **Criterios de Aceite:** O retorno a partir do plano de governo restaura a ficha do candidato sem fechar o PWA em plataformas Android, iOS e desktop.

#### `[B.8]` Reavaliacao Ergonomica do Botao de Atualizacao (Pull-to-Refresh)
* **Contexto e Problema:** A presenca de um botao de recarga manual na `AppBar` ocupa espaco util de tela e pode ser redundante, uma vez que a arquitetura do aplicativo opera sob o paradigma *Stale-While-Revalidate* (SWR) com atualizacao automatica em segundo plano.
* **Solucao de Engenharia:**
  1. Conduzir auditoria de usabilidade para despoluir o cabecalho da aplicacao.
  2. Adotar o componente `RefreshIndicator` (*Pull-to-Refresh*) nas listagens de rolagem ([CandidateListPage](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/pages/candidate_list_page.dart) e [CandidateDetailPage](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/pages/candidate_detail_page.dart)).
  3. Manter a acao manual de repeticao apenas em telas de erro ou aviso de indisponibilidade de conexao.
* **Criterios de Aceite:** Atualizacao de dados plenamente acessivel via gesto de arraste para baixo e remocao de controles superfluos na barra superior.

#### `[B.9]` Alternancia Explicita de Temas (Claro e Escuro) com Persistencia Local
* **Contexto e Problema:** A aplicacao possui tokens de cores semanticas definidos para os modos Claro e Escuro ([AppSemanticColors](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/theme/app_semantic_colors.dart)), porem nao disponibiliza controle na interface para alternancia voluntaria pelo usuario, restringindo-se a deteccao automatica do sistema operacional.
* **Solucao de Engenharia:**
  1. Implementar gerenciador de estado de tema (`ThemeBloc` ou `ThemeCubit`) com os estados `ThemeMode.system`, `ThemeMode.light` e `ThemeMode.dark`.
  2. Persistir a selecao do eleitor em armazenamento local (Drift/SQLite ou preferencias do navegador).
  3. Incorporar botao/alternador acessivel no cabecalho ou menu de opcoes da aplicacao, provendo feedback sonoro/semantico sobre o modo ativo.
* **Criterios de Aceite:** Transicao suave entre temas sem reconstrucoes redundantes de arvore e preservacao da conformidade de contraste WCAG 2.1 AA em ambas as configuracoes.

#### `[B.10]` Filtragem Multipartidaria Simultanea (Selecao Multipla de Partidos)
* **Contexto e Problema:** O filtro partidario atual suporta apenas a selecao de uma unica legenda por vez, restringindo comparacoes entre coligacoes ou blocos partidarios afins.
* **Solucao de Engenharia:**
  1. Evoluir [CandidateListState](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/blocs/candidate_list/candidate_list_state.dart) para substituir o campo singular `selectedParty` por `Set<String> selectedParties`.
  2. Adaptar o predicado linear de filtragem O(N) no [CandidateListBloc](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/blocs/candidate_list/candidate_list_bloc.dart) para validar a pertinencia do candidato ao conjunto de siglas selecionadas.
  3. Atualizar o [CandidateFilterBottomSheet](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/lib/presentation/widgets/candidate_filter_bottom_sheet.dart) com interface de multipla selecao (chips agrupados com busca por sigla ou nome da federacao).
* **Criterios de Aceite:** Capacidade de selecionar e desmarcar multiplas legendas simultaneamente, com atualizacao instantanea da listagem e cobertura de 100% nos testes unitarios do BLoC.

#### `[B.11]` Modulo Comparador Analitico Direto entre Candidaturas Concorrentes
* **Contexto e Problema:** Eleitores necessitam alternar repetidamente entre fichas individuais para cotejar patrimonio, propostas e historico de registros entre candidatos concorrentes ao mesmo cargo.
* **Solucao de Engenharia:**
  1. Criar fluxo de selecao comparativa na listagem principal (permitindo marcar de 2 a 3 candidatos do mesmo pleito e cargo).
  2. Desenvolver a tela `CandidateComparisonPage` estruturada em colunas responsivas, apresentando matriz analitica de comparacao:
     * Resumo da chapa e situacao juridica do registro.
     * Somatorio e categorizacao discriminada de bens declarados.
     * Limites legais de gastos fixados pelo TSE.
     * Grau de instrucao, ocupacao declarada e acesso direto as propostas de governo.
  3. Integrar gerenciamento de estado via `CandidateComparisonBloc` isolado e testavel.
* **Criterios de Aceite:** Matriz responsiva compativel com telas compactas (com rolagem horizontal sincronizada) e telas expandidas, assegurando estrita neutralidade de ordenacao e exibicao.

#### `[B.12]` Adequacao de Metadados de Instalacao do PWA (Manifest e Titulo)
* **Contexto e Problema:** Ao adicionar a aplicacao a tela inicial do dispositivo, o nome atribuido ao atalho e o identificador tecnico `quem_votar` com descricao padrao de template gerado pelo Flutter (`"A new Flutter project."`).
* **Solucao de Engenharia:**
  1. Atualizar [web/manifest.json](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/web/manifest.json):
     * `"name": "Quem Votar | Transparência e Dados Oficiais do TSE"`
     * `"short_name": "Quem Votar"`
     * `"description": "Consulta pública, transparente e acessível a candidaturas, patrimônio e dados eleitorais oficiais do Tribunal Superior Eleitoral (TSE)."`
     * `"background_color": "#F8FAFC"`
     * `"theme_color": "#1E40AF"`
  2. Sincronizar metatags em [web/index.html](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/web/index.html) (`apple-mobile-web-app-title`, `title` e descricoes semanticas).
* **Criterios de Aceite:** Instalacao em dispositivo movel e desktop exibindo o rotulo institucional "Quem Votar" com descricao e paleta visual oficiais.


