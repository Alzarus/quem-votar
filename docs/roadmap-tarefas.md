# Estrutura Analitica de Projeto e Roadmap de Implementacao (WBS)

## Projeto: Plataforma de Transparencia Civica e Acompanhamento Eleitoral
**Documento:** WBS-001  
**Classificacao:** Plano Operacional, Rastreabilidade e Gestao de Tarefas  
**Revisao:** 1.0.0  
**Data:** 13 de setembro de 2026  
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
| T5.1   | Tokens semanticos de cor (HSL) e temas Claro/Escuro         | [PENDENTE]     |
| T5.2   | Escala tipografica acessivel com textScaler dinamico        | [PENDENTE]     |
| T5.3   | Componentes atomicos acessiveis (Avatar, Badge, Chips, Card)| [PENDENTE]     |
| T5.4   | Testes de widget e verificacao WCAG (alvos 48dp e Semantics)| [PENDENTE]     |
+--------+-------------------------------------------------------------+----------------+

+---------------------------------------------------------------------------------------+
| FASE 6: GERENCIAMENTO DE ESTADO E TELAS (PRESENTATION LAYER)                          |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T6.1   | BLoC de Selecao de Eleicao, UF e Cargo (Padrao: 2026/BR)    | [PENDENTE]     |
| T6.2   | BLoC de Listagem de Candidatos com busca textual e debounce | [PENDENTE]     |
| T6.3   | BLoC de Detalhes do Candidato e Auditoria Patrimonial       | [PENDENTE]     |
| T6.4   | Pagina responsiva CandidateListPage (1, 2 e 3 colunas)      | [PENDENTE]     |
| T6.5   | Pagina de detalhes CandidateDetailPage                     | [PENDENTE]     |
| T6.6   | Testes de integracao de fluxo de tela                       | [PENDENTE]     |
+--------+-------------------------------------------------------------+----------------+

+---------------------------------------------------------------------------------------+
| FASE 7: INFRAESTRUTURA DE BORDA, DEPLOY E VALIDACAO EM PRODUCAO                       |
+--------+-------------------------------------------------------------+----------------+
| Codigo | Descricao e Escopo Tecnico                                  | Status         |
+--------+-------------------------------------------------------------+----------------+
| T7.1   | Estruturacao de /opt/quemvotar e Docker Compose na VM       | [PENDENTE]     |
| T7.2   | Configuracao do Nginx Alpine com Micro-Proxy de Cache TSE   | [PENDENTE]     |
| T7.3   | Configuracao do Proxy Host e SSL no Nginx Proxy Manager     | [PENDENTE]     |
| T7.4   | Build de producao web e deploy automatizado via SCP         | [PENDENTE]     |
| T7.5   | Validacao de operacao offline (PWA) e auditoria de cache    | [PENDENTE]     |
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
