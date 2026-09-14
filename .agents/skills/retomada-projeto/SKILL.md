---
name: retomada-projeto
description: >-
  Protocolo compulsorio para inicializacao, orientacao e retomada de desenvolvimento
  do projeto civico Quem Votar em novas sessoes. Mapeia o estado atual via WBS,
  aplica os 13 principios de Clean Code para IA, governanca, harness de testes,
  acessibilidade WCAG e integracao de infraestrutura sem uso de emojis.
---

# Skill: Retomada de Projeto e Harness Operacional (Quem Votar)

Esta skill define o protocolo estrito de orientacao, inspecao de estado e continuidade de desenvolvimento para o projeto civico multiplataforma *Quem Votar*. Qualquer agente que assuma o projeto em uma nova sessao de chat deve seguir este runbook passo a passo.

---

## 1. Protocolo de Inicializacao e Reconhecimento de Estado

Ao iniciar ou retomar uma sessao de trabalho, o agente deve executar compulsoriamente os seguintes passos antes de efetuar qualquer alteracao de codigo:

1. **Inspecao do Git:**
   * Executar `git status` e `git log -n 5 --oneline` para verificar a branch ativa e os ultimos commits entregues.
2. **Leitura do WBS e Rastreamento de Tarefas:**
   * Ler `docs/roadmap-tarefas.md` para identificar:
     * A Fase em andamento (Fase 0 a Fase 7).
     * A proxima tarefa com status `[PENDENTE]`.
     * Se existem tarefas em estado intermediario `[EM PROGRESSO]`.
3. **Cruzamento com Contratos e Arquitetura:**
   * Caso a tarefa envolva rede ou dados do TSE, verificar os schemas validados em `docs/api-contracts.md`.
   * Caso envolva persistencia ou cache, consultar as tabelas e indices em `docs/arquitetura.md`.
   * Caso envolva componentes visuais, acionar a skill `ui-ux-pro` e consultar `docs/design-system.md`.
   * Caso envolva deploy ou conexoes de borda, consultar `docs/infraestrutura-web.md`.

---

## 2. As Treze Regras Compulsorias de Engenharia (Clean Code para Agentes)

Em observancia a `AGENTS.md` e `docs/convencoes-codigo.md`:

1. **Funcoes Pequenas (4 a 20 linhas):** Uma funcao executa uma unica operacao. Se ultrapassar 20 linhas, fragmentar em subfuncoes privadas autodocumentadas.
2. **Arquivos Compactos (< 300 linhas):** Limite maximo absoluto de 500 linhas. Classes volumosas devem ser decompostas em arquivos proprios.
3. **Single Responsibility Principle (SRP):** Cada arquivo, classe ou modulo possui apenas uma razao para mudar.
4. **Nomes Distintivos e Greppaveis:** Evitar termos genericos (`data`, `item`, `handler`, `Manager`, `Helper`). Adotar nomes com menos de 5 ocorrencias em buscas lexicais (ex: `TseCandidateSummaryMapper`, `CandidateAssetsAggregationService`).
5. **Tipagem Forte e Estrita:** Proibicao absoluta de `dynamic` ou `Map<String, dynamic>` trafegando nas camadas de Dominio e Apresentacao. Toda estrutura deve ser convertida em classes tipadas e imutaveis na camada de Dados.
6. **DRY (Don't Repeat Yourself):** Centralizacao estrita de logica de negocios e conversao de dados em modulos reutilizaveis.
7. **Testes Headless F.I.R.S.T:** Cobertura de 100% para mappers, regras de negocio e calculos financeiros. Testes executaveis via terminal sem internet utilizando fixtures reais em `test/fixtures/` e fakes nomeados.
8. **Arvore Canonica e Previsivel:**
   * `lib/core/`: Utilitarios de rede, tipos `Result<T, Failure>` e excecoes ricas.
   * `lib/domain/`: Entidades puras, Value Objects e contratos abstratos de repositorios.
   * `lib/data/`: Implementacoes de repositorios, datasources, DAOs Drift e mappers.
   * `lib/presentation/`: BLoCs, paginas responsivas e widgets acessiveis.
   * `test/`: Espelha fielmente a arvore de `lib/`.
9. **Injecao de Dependencias:** Dependencias devem ser fornecidas via construtor ou interfaces abstratas, viabilizando substituicao por implementacoes fakes.
10. **Fluxo Logico Plano:** Maximo de 2 niveis de indentacao. Empregar compulsoriamente clausulas de guarda (*guard clauses*) e retornos antecipados (*early returns*).
11. **Excecoes Ricas em Contexto:** Toda excecao deve informar o valor recebido, o formato esperado e o contexto operacional.
12. **Formatacao e Linter Padrao:** Padrao determinado exclusivamente por `dart format --line-length 100 .` e `flutter analyze`.
13. **Comentarios de Intencao:** Comentar o PORQUE de contornos, restricoes do TSE/Akamai ou particularidades legais. E proibido apagar comentarios de contexto produzidos em etapas anteriores.

---

## 3. Regras Inviolaveis de Governanca e Acessibilidade

* **Proibicao Absoluta de Emojis:** Nao empregar simbolos pictoriais ou emojis em qualquer arquivo de codigo, documentacao, comentarios ou mensagens de commit. Utilizar notacao textual: `[OK]`, `[PENDENTE]`, `[CONCLUIDO]`, `[ERRO]`.
* **Tom Profissional, Academico e Racional:** Redacao técnica formal, impessoal e sem cliches automatizados.
* **Acessibilidade WCAG 2.1 AA:**
  * Contraste cromatico minimo de 4,5:1 para texto normal.
  * Alvos de toque de no minimo 48x48 dp (`kMinInteractiveDimension`).
  * Rotulos textuais semanticos em componentes interativos via `Semantics`.
  * Suporte compulsorio a ampliacao de tipografia pelo sistema operacional (`textScaler`).
* **Neutralidade Algoritmica Estrita:** Ordenacao padrao exclusivamente alfabetica por nome de urna ou numerica crescente por legenda partidaria. Vedada qualquer forma de favorecimento ideologico ou partidario.

---

## 4. Harness Operacional de Validacao

Toda intervencao de codigo deve ser validada no terminal PowerShell atraves dos seguintes comandos sequenciais:

```powershell
# 1. Validacao e execucao de suite de testes com cobertura
flutter test --no-pub --coverage

# 2. Analise estatica de regras e linter
flutter analyze

# 3. Formatacao compulsoria do codigo-fonte
dart format --line-length 100 .

# 4. Regeneracao de modelos relacionais Drift (quando aplicavel)
dart run build_runner build --delete-conflicting-outputs
```

---

## 5. Protocolo de Finalizacao e Transicao de Ciclo

Ao concluir uma tarefa:
1. Validar que os 4 comandos do harness foram executados sem erros.
2. Atualizar o indicador de status em `docs/roadmap-tarefas.md` de `[PENDENTE]` para `[CONCLUIDO]`.
3. Realizar commit semantico com mensagem formal (ex: `feat(core): implementar cliente Dio com interceptor Akamai [T1.2]`).
4. Realizar `git push origin master`.
5. Fornecer resumo objetivo das entregas e instrucoes concisas para a proxima tarefa do roadmap.
