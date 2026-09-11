# Normas de Codificacao, Engenharia e Convencoes para Flutter

## Projeto: Plataforma de Transparencia Civica e Acompanhamento Eleitoral
**Documento:** COD-001  
**Classificacao:** Padroes de Programacao, Qualidade e Arquitetura de Codigo  
**Revisao:** 1.0.0  
**Data:** 11 de setembro de 2026  

---

## 1. Fundamentacao: Clean Code na Era dos Agentes de IA

Este documento traduz os principios classicos da Engenharia de Software e a reformulacao contemporanea do Clean Code para agentes de inteligencia artificial formulada por Fabio Akita. O leitor e mantenedor primario deste repositorio e o agente automatizado em conjunto com o desenvolvedor. Para assegurar que as mudancas sejam velozes, baratas em tokens, precisas e isentas de regressoes silenciosas, o codigo deve obedecer compulsoriamente aos treze preceitos tecnicos abaixo detalhados.

---

## 2. As Treze Regras Compulsorias de Codigo

### Regra 1: Extensao de Funcoes (4 a 20 linhas)
* Toda funcao ou metodo deve executar uma unica tarefa bem delimitada em no maximo 20 linhas de corpo.
* Caso uma rotina acumule mais de 20 linhas, ela deve ser decomposta em metodos auxiliares privados expressivos com nomes autodocumentados. Funcoes curtas cabem em uma unica chamada de ferramenta do agente, permitindo analise atenta e completa.

### Regra 2: Extensao de Arquivos (Abaixo de 300 linhas, limite maximo de 500)
* Um arquivo Dart deve manter sua extensao preferencialmente entre 150 e 300 linhas de codigo.
* E expressamente proibido ultrapassar 500 linhas em um unico arquivo. Classes extensas devem ser fragmentadas por responsabilidade (ex: separar classes de estado, eventos, widgets filhos e conversores de dados em arquivos proprios).

### Regra 3: Single Responsibility Principle (SRP) Rigoroso
* Cada arquivo, classe ou biblioteca deve possuir apenas uma unica razao para mudar.
* Um conversor de dados do TSE (`TseCandidateModelMapper`) nao deve conter regras de agregacao financeira; uma tela visual (`CandidateListPage`) nao deve conter chamadas HTTP ou operacoes diretas de banco de dados.

### Regra 4: Nomes Significativos, Distintivos e Greppaveis
* Evitar terminologias genericas como `data`, `item`, `handler`, `Manager`, `Service`, `Helper`, `Processor`.
* Adotar nomes unicos e descritivos que retornem menos de 5 ocorrencias ao executar busca lexical (`grep`/`ripgrep`) no repositorio.
* Exemplos aceitos: `TseRegistrationStatusParser`, `CandidateAssetsAggregationService`, `CandidateSummaryCard`.
* Exemplos rejeitados: `DataParser`, `AggregationHelper`, `CardWidget`.

### Regra 5: Tipagem Estrita e Explicita
* E terminantemente proibido o emprego do tipo `dynamic`, de mapas nao-tipados (`Map<String, dynamic>`) ou de `Object` sem cast defensivo em camadas de Dominio e Apresentacao.
* Todas as assinaturas de metodos, variaveis de instancia e parametros devem declarar seus tipos concretos explicitamente.
* Modelos de transferencia de dados (DTOs) devem converter os mapas JSON brutos em objetos tipados e imutaveis no instante exato de sua recepcao na camada de dados (`data/`).

### Regra 6: DRY (Don't Repeat Yourself) Intransigente
* Nao tolerar duplicacao de logica de negocios, validacao ou parsing. O agente de IA nao possui rastreamento automatico para copias espalhadas em arquivos distintos. Qualquer duplicacao gera inconsistencias imediatas em refatoracoes subsequentes.

### Regra 7: Testes Headless F.I.R.S.T
* Todo codigo de Dominio e Camada de Dados deve nascer acompanhado de testes automatizados unitarios executaveis via terminal em comando unico: `flutter test`.
* Caracteristicas F.I.R.S.T compulsorias:
  * **Fast:** Testes unitarios devem rodar em milissegundos.
  * **Independent:** Nenhum teste depende da ordem de execucao ou do estado deixado por outro teste.
  * **Repeatable:** Executam com dados mocados (`fixtures/`) sem conexao externa a internet ou servidores governamentais.
  * **Self-Validating:** O resultado e estritamente booleano (sucesso ou falha clara).
  * **Timely:** Testes escritos no mesmo ciclo de desenvolvimento da funcionalidade.
* Mocks de I/O devem utilizar classes falsas nomeadas com comportamento previsivel (`FakeTseRemoteDataSource`), evitando dubles anonimos frageis.

### Regra 8: Estrutura de Diretorios Canonica e Previsivel
* A arvore de diretorios deve refletir as convencoes estritas de Clean Architecture:
  * `lib/core/`: Constantes, utilitarios de rede, tipos de retorno (`Result<T, Failure>`) e excecoes.
  * `lib/domain/`: Entidades de negocio puras, Value Objects e interfaces de repositorios.
  * `lib/data/`: Implementacoes de repositorios, datasources (remoto e Drift SQLite) e models/mappers.
  * `lib/presentation/`: Gerenciamento de estado (BLoC/Cubit), telas e widgets acessiveis.
* O caminho de um arquivo de teste deve espelhar fielmente o caminho do arquivo de producao correspondente (ex: `lib/data/mappers/candidate_mapper.dart` -> `test/unit/data/mappers/candidate_mapper_test.dart`).

### Regra 9: Injecao de Dependencias e Testabilidade
* Todas as classes de servico e repositorio devem receber suas dependencias atraves de construtores publicos com inversao de controle:
  ```dart
  class CandidateRepositoryImpl implements CandidateRepository {
    final TseRemoteDataSource remoteDataSource;
    final CandidateLocalDataSource localDataSource;

    CandidateRepositoryImpl({
      required this.remoteDataSource,
      required this.localDataSource,
    });
  }
  ```
* E vedada a instanciacao rigida direta de clientes de rede ou bancos de dados no interior de classes de negocio.

### Regra 10: Fluxo Logico Plano (Maximo de 2 Niveis de Indentacao)
* Evitar aninhamento excessivo de blocos condicionais (`if`, `for`, `switch`).
* Aplicar compulsoriamente **clausulas de guarda** (*guard clauses*) e **retornos antecipados** (*early returns*):
  ```dart
  // Correto: Logica plana com clausula de guarda
  CandidateSummary parseCandidate(Map<String, dynamic> json) {
    final id = json['id'] as int?;
    if (id == null) {
      throw TseDataParseException('Identificador id ausente ou nulo.');
    }
    return CandidateSummary(...);
  }
  ```

### Regra 11: Excecoes Ricas em Contexto
* Toda excecao lancada pelo sistema deve declarar explicitamente:
  1. O valor recebido que originou o erro.
  2. O formato ou tipo esperado.
  3. O contexto da operacao.
* Mensagens genericas como `"Erro ao carregar dados"` ou `Exception("invalid input")` sao vetadas.

### Regra 12: Formatacao Oficial e Linter
* Toda alteracao deve ser formatada e verificada pelos comandos oficiais:
  ```powershell
  dart format --line-length 100 .
  flutter analyze
  ```
* E proibido discutir preferencias esteticas fora dos padroes impostos pelo analisador e formatador padrao da linguagem.

### Regra 13: Comentarios de Intencao e Proveniencia
* Os comentarios de codigo devem explicar exclusivamente o **PORQUE** de determinada decisao tecnica:
  * Contorno de bugs conhecidos na API do TSE.
  * Justificativa de cabecalhos especificos requeridos pelo WAF Akamai.
  * Referencia a legislacao eleitoral aplicavel ou portarias normativas.
* E proibido redigir comentarios obvios que apenas parafraseiam a sintaxe (ex: `// incrementa o contador`).
* **Regra de Preservacao do Agente:** E expressamente proibido remover, durante refatoracoes, comentarios contextuais e docstrings gerados anteriormente pelo proprio agente ou pelo desenvolvedor. Tais notas constituem a memoria factual indispensavel para iteracoes futuras.

---

## 3. Convencoes de Nomenclatura Dart

* **Arquivos e Pastas:** Formato `snake_case` (ex: `candidate_summary_card.dart`, `tse_remote_data_source.dart`).
* **Classes, Enums e Tipos:** Formato `PascalCase` (ex: `CandidateSummary`, `RegistrationStatus`).
* **Variaveis, Metodos e Parametros:** Formato `camelCase` (ex: `totalAssetsAmount`, `fetchCandidatesByRole`).
* **Constantes Globais:** Formato `lowerCamelCase` ou `camelCase` conforme recomendacao oficial do Effective Dart (ex: `kMinInteractiveDimension`, `defaultRequestTimeout`).
