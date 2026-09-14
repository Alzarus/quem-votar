# Guia de Desenvolvimento, Governanca e Harness do Projeto

> [!IMPORTANT]
> Este documento constitui a fonte primordial de diretrizes operacionais, arquiteturais e de governanca para desenvolvedores e agentes de inteligencia artificial atuantes no projeto. Todas as instrucoes aqui dispostas sao de observancia compulsoria.

---

## 1. Visao e Dominio do Projeto

Aplicativo civico de codigo aberto (Civic Tech) multiplataforma desenvolvido em Flutter para consulta publica, transparente e acessivel a dados eleitorais oficiais do Tribunal Superior Eleitoral (TSE).
O sistema transforma dados brutos e instaveis de candidaturas, patrimonio declarado, situacao de registro e propostas em informacoes estruturadas, compreensiveis e auditaveis para o eleitor brasileiro em todo o territorio nacional.

* **Dominio:** Transparencia Publica, Dados Eleitorais e Fiscalizacao Democratica.
* **Escopo Territorial:** Cobertura integral das 27 Unidades Federativas (26 estados e Distrito Federal) e pleitos presidenciais/nacionais (`BR`), alem de estrutura extensivel para pleitos municipais.
* **Fonte de Dados:** API DivulgaCandContas (TSE) e Repositorio de Dados Abertos Eleitorais do TSE.
* **Principio Deontologico Fundamental:** Neutralidade estrita. E terminantemente proibido qualquer algoritmo, filtro ou ordenacao que conceda primazia ou favorecimento a partidos, candidatos ou espectros ideologicos especificos. Os dados devem refletir com exatidao os registros oficiais da Justica Eleitoral.

---

## 2. Regras Universais e Compulsorias do Repositorio

1. **Proibicao Absoluta de Emojis:** Nao e tolerado o emprego de simbolos pictoriais ou emojis em arquivos de codigo-fonte, configuracoes, documentacao tecnica em Markdown ou mensagens de controle de versao (commits). Estados devem ser expressos por notacao textual padronizada (ex: `[OK]`, `[PENDENTE]`, `[ERRO]`).
2. **Tom Profissional e Academico:** Toda a comunicacao, comentarios de codigo e mensagens de commit devem adotar registro formal, impessoal e estritamente tecnico.
3. **Escrita Humanizada e Racional:** Redigir textos tecnicos sem cliches ou padroes repetitivos de geracao automatizada. A comunicacao deve ser direta, fundamentada e objetiva.
4. **Verificabilidade e Referencias Factuais:** E proibida a criacao de referencias, leis ou fontes de dados inexistentes. Quando uma afirmacao depender de base factual externa nao verificada no momento, apor a marcacao `[FONTE REQUERIDA]`.
5. **Ambiente de Execucao:** Sistema Operacional Windows 11 com terminal PowerShell.

---

## 3. Harness de Engenharia: Clean Code para Agentes de IA

Em consonancia com as diretrizes de desenvolvimento orientado a agentes de inteligencia artificial e engenharia de software de alta disciplina, o codigo-fonte deve seguir os 13 principios de densidade e operabilidade tecnica:

1. **Funcoes Pequenas:** Entre 4 e 20 linhas de codigo. Se uma funcao ultrapassar essa extensao, deve ser fragmentada em subfuncoes com responsabilidade unica.
2. **Arquivos Compactos:** Extensao ideal entre 150 e 300 linhas de codigo (limite maximo absoluto de 500 linhas). Modulos volumosos devem ser decompostos por responsabilidade.
3. **Single Responsibility Principle (SRP):** Cada classe, modulo ou arquivo deve possuir uma unica razao para mudar, permitindo leitura completa e analise isolada pelo modelo sem saturacao de contexto.
4. **Nomes Significativos, Unicos e Greppaveis:** Evitar termos genericos como `data`, `handler`, `Manager`, `Service`, `Helper`. Adotar nomes distintivos (ex: `TseCandidateSummaryMapper`, `CandidateAssetsAggregationService`) que retornem menos de 5 resultados em buscas lexicais (`grep`/`ripgrep`) no repositorio.
5. **Tipagem Estrita e Explicita:** Proibicao estrita do uso de `dynamic`, `Object` sem cast seguro ou mapas genericos `Map<String, dynamic>` trafegando nas camadas de Dominio e Apresentacao. Toda estrutura deve ser mapeada para classes tipadas e imutaveis.
6. **DRY (Don't Repeat Yourself):** Eliminar duplicacao de codigo. O agente nao possui memoria gravitacional automatica para rastrear alteracoes em copias dispersas; a centralizacao em funcoes e modulos reutilizaveis garante refatoracoes confiaveis.
7. **Testes Headless F.I.R.S.T:** Testes automatizados executaveis pelo agente de forma autonoma sem dependencia de configuracoes manuais, servidores externos ou interfaces graficas. Cobertura compulsoria de 100% para mappers, parsers de dados e calculos financeiros.
8. **Estrutura de Diretorios Canonica e Previsivel:** Organizacao rigorosa de pastas segundo as convencoes do Flutter e Clean Architecture, permitindo deducao de caminhos de arquivos sem varreduras superfluas de diretorio.
9. **Injecao de Dependencias e Testabilidade:** Dependencias externas (clientes HTTP, bancos de dados locais, sensores) devem ser fornecidas via construtor ou interfaces abstratas, viabilizando a substituicao por implementacoes falsas nomeadas (`FakeTseRemoteDataSource`) durante os testes.
10. **Fluxo Logico Plano:** Maximo de 2 niveis de indentacao. Uso compulsorio de clausulas de guarda (*guard clauses*) e retornos antecipados (*early returns*), evitando aninhamentos profundos de estruturas condicionais.
11. **Excecoes Ricas em Contexto:** Toda excecao lancada deve conter o valor que originou a falha, o formato esperado e o contexto operacional (ex: `TseDataParseException('Valor invalido para totalDeBens: $raw. Esperado numerico positivo.')`).
12. **Formatacao e Linter Padrao:** O estilo de formatacao e determinado compulsoriamente pelas ferramentas oficiais da linguagem: `dart format .` e `flutter analyze`. Nao debater preferencias estilisticas fora do analisador padrao.
13. **Comentarios de Intencao e Proveniencia:** Comentar o PORQUE de decisoes de contorno, particularidades da legislacao eleitoral, restricoes do WAF Akamai ou contorno de anomalias no payload do TSE. E proibido escrever comentarios obvios sobre sintaxe. E terminantemente proibido podar ou apagar comentarios de contexto produzidos pelo proprio agente durante refatoracoes.

---

## 4. Matriz de Documentacao Modular (`docs/`)

| Dominio | Documento | Finalidade e Escopo |
|---|---|---|
| **Requisitos e Negocio** | [`docs/prd.md`](docs/prd.md) | Visao do produto, escopo nacional, personas, casos de uso (UC01 a UC04), RFs, RNFs e acessibilidade. |
| **Arquitetura e Redes** | [`docs/arquitetura.md`](docs/arquitetura.md) | Topologia Flutter standalone, persistencia Drift (SQLite), cache SWR sob demanda, contencao Akamai e Circuit Breaker. |
| **Contratos e Schemas** | [`docs/api-contracts.md`](docs/api-contracts.md) | Mapeamento exaustivo de todos os endpoints do TSE, codigos de cargo (1 a 13), enums de/para e entidades Dart. |
| **Design System e Acessibilidade** | [`docs/design-system.md`](docs/design-system.md) | Tokens, WCAG 2.1 AA (contraste 4,5:1, alvo de toque 48x48dp, textScaler, semantica) e responsividade. |
| **Convencoes de Codigo** | [`docs/convencoes-codigo.md`](docs/convencoes-codigo.md) | Regras estritas de codificacao Dart/Flutter, arquitetura de camadas, testes unitarios e harness de validacao. |
| **Infraestrutura e Deploy** | [`docs/infraestrutura-web.md`](docs/infraestrutura-web.md) | Topologia de hospedagem VM Contabo, SNI multidominio, Nginx, SSL Let's Encrypt e deploy Flutter Web. |
| **Gestao e Tarefas** | [`docs/roadmap-tarefas.md`](docs/roadmap-tarefas.md) | Estrutura Analitica de Projeto (WBS), divisao em Fases 0 a 7, status e criterios de aceitacao. |

---

## 5. Estrutura Canonica de Diretorios

```
.agents/
├── mcp_config.json           # Configuracao do Context7 MCP e integracoes locais
└── skills/
    ├── ui-ux-pro/            # Skill de inteligencia visual, tokens e acessibilidade
    └── retomada-projeto/     # Skill de orientacao, harness e continuidade operacional
docs/
├── prd.md                    # Requisitos do Produto (PRD) e escopo nacional
├── arquitetura.md            # Arquitetura tecnica Flutter, persistencia e resiliencia
├── api-contracts.md          # Especificacao de endpoints, schemas do TSE e entidades
├── design-system.md          # Tokens visuais, WCAG 2.1 AA e responsividade adaptativa
├── convencoes-codigo.md      # Convencoes Dart/Flutter baseadas no padrao Fabio Akita
├── infraestrutura-web.md     # Roteamento Nginx, deploy VM Contabo e Flutter Web subpath
└── roadmap-tarefas.md        # WBS, rastreabilidade operacional e matriz de tarefas
lib/
├── core/                     # Constantes, configuracoes de rede, tipos Result e falhas
│   ├── network/              # Cliente Dio com interceptor para cabecalhos Akamai
│   └── errors/               # Excecoes tipadas e classes Failure com contexto
├── domain/                   # Entidades imutaveis de negocio e contratos de repositorios
│   ├── entities/             # Entidades puras sem dependencia de frameworks
│   └── repositories/         # Interfaces abstratas de acesso a dados
├── data/                     # Implementacoes de repositorios, datasources e mappers
│   ├── datasources/          # Fonte remota (TSE API) e fonte local (Drift/SQLite)
│   ├── models/               # DTOs para deserializacao com tratamento defensivo de nulos
│   └── repositories/         # Implementacao com estrategia de cache sob demanda (SWR)
└── presentation/             # Telas, componentes visuais acessiveis e gerencia de estado (BLoC)
    ├── blocs/                # Gerenciadores de fluxo de estado
    ├── pages/                # Telas adaptativas por breakpoint
    └── widgets/              # Componentes atômicos com suporte a Semantics e WCAG
test/
├── fixtures/                 # Payloads JSON reais do TSE para testes isolados
├── unit/                     # Testes unitarios de mappers, use cases e calculos
└── widget/                   # Testes de componentes visuais e acessibilidade
```

---

## 6. Comandos Operacionais do Harness

Toda intervencao de codigo deve ser validada por meio dos seguintes comandos executados no PowerShell:

* **Execucao de Testes:** `flutter test --no-pub --coverage`
* **Analise Estatica:** `flutter analyze`
* **Formatacao Obrigatoria:** `dart format --line-length 100 .`
* **Regeneracao de Codigo (Drift/Build Runner):** `dart run build_runner build --delete-conflicting-outputs`
