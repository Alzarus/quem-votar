# Documento de Requisitos do Produto (PRD)

## Projeto: Plataforma de Transparencia Civica e Acompanhamento Eleitoral
**Documento:** PRD-001  
**Classificacao:** Especificacao Funcional e de Negocio  
**Revisao:** 2.0.0  
**Data:** 11 de setembro de 2026  

---

## 1. Visao Geral e Justificativa

### 1.1 Declaracao do Problema
O acesso do cidadao brasileiro as informacoes sobre candidaturas politicas durante os periodos eleitorais e assegurado pela Lei de Acesso a Informacao (Lei nº 12.527/2011) e pelo Codigo Eleitoral (Lei nº 4.737/1965). O Tribunal Superior Eleitoral (TSE) disponibiliza tais dados por meio do sistema DivulgaCandContas. Contudo, a plataforma oficial apresenta barreiras tecnicas substanciais que afetam eleitores em todo o territorio nacional:
1. Interface web complexa e de dificil usabilidade em dispositivos moveis de entrada e telas de resolucoes variadas.
2. Inexistencia de camada publica estavel e documentada para consumo direto e veloz por dispositivos de usuarios finais.
3. Instabilidade frequente decorrente de picos sazonais massivos de acesso no periodo de campanha (agosto a outubro).
4. Dispersao de dados criticos (patrimonio declarado, situacao juridica do registro, prestacao de contas e propostas programaticas de governo) em estruturas heterogeneas e arquivos PDF nao indexados.
5. Barreiras de acessibilidade digital para pessoas com deficiencias visuais ou motoras e eleitores idosos sob condicoes precarias de conectividade.

### 1.2 Declaracao de Visao do Produto
Desenvolver uma aplicacao civica (Civic Tech) de codigo aberto, estritamente neutra e orientada a dados, desenvolvida em Flutter para dispositivos moveis e multiplataforma. O produto atua de forma autonoma e completa, intermediando, estruturando e armazenando localmente as informacoes publicas do TSE para os 26 Estados, o Distrito Federal e o ambito nacional (`BR`). O aplicativo fornece uma experiencia veloz, acessivel (WCAG 2.1 AA), inteligivel e resiliente de consulta a registros de candidatura, evolucao patrimonial, limites de gastos e regularidade eleitoral.

---

## 2. Publico-Alvo e Personas

### 2.1 Persona Primaria: O Eleitor Sob Conexoes Variaveis
* **Nome Ficticio:** Carlos Eduardo, 34 anos.
* **Ocupacao:** Analista administrativo, residente em Salvador/BA (com perfil representativo de capitais e cidades do interior do Brasil).
* **Comportamento Tecnologico:** Utiliza primordialmente smartphone intermediario com tela de 6 polegadas sob redes moveis 3G/4G sujeitas a oscilacoes; busca validar informacoes sobre candidaturas locais e federais na semana da eleicao.
* **Necessidades Centrais:**
  * Consultar candidatos a Deputado Federal, Estadual, Senador, Governador e Presidente com carregamento instantaneo.
  * Verificar a situacao judicial do registro de candidatura (se esta deferido ou pendente de recurso judicial).
  * Auditar o patrimonio declarado sem termos contabeis obscuros e de forma visualmente clara.
* **Dores:** Falhas constantes de carregamento ao tentar acessar sites governamentais em periodos proximos ao pleito; consumo excessivo do pacote de dados em conexoes moveis limitadas.

### 2.2 Persona Secundaria: O Cidadao com Necessidades de Acessibilidade
* **Nome Ficticio:** Teresa Cristina, 68 anos.
* **Ocupacao:** Aposentada, residente em Belo Horizonte/MG.
* **Comportamento Tecnologico:** Utiliza configuracoes de ampliacao de texto do sistema operacional (escala de fonte em 140%) e, ocasionalmente, leitor de tela (TalkBack/VoiceOver).
* **Necessidades Centrais:**
  * Navegar pela lista de candidatos sem que os textos fiquem cortados ou sobrepostos devido ao tamanho ampliado da tipografia.
  * Contraste cromático elevado para leitura facil sob luz solar direta.
  * Botoes e elementos interativos amplos, faceis de acionar com um toque sem erros motores involuntarios.

### 2.3 Persona Terciaria: O Pesquisador e Jornalista Civico
* **Nome Ficticio:** Dra. Mariana Lopes, 42 anos.
* **Ocupacao:** Cientista politica e pesquisadora.
* **Necessidades Centrais:**
  * Comparar dados patrimoniais e coligacoes entre diferentes estados do Brasil.
  * Acessar identificadores oficiais unicos do TSE (`idCandidato`, numero de processo eleitoral) para rastreabilidade factual e citacao documental.

---

## 3. Casos de Uso Principais (Use Cases)

### UC01: Consulta Parametrizada em Ambito Nacional
* **Ator:** Cidadao / Eleitor.
* **Pre-condicoes:** Aplicativo em execucao com ou sem acesso imediato a internet.
* **Fluxo Principal:**
  1. O usuario seleciona o pleito eleitoral (ex: Eleicoes Gerais 2026).
  2. O usuario seleciona a abrangencia territorial: Nacional (`BR`) ou uma das 27 Unidades Federativas (ex: SP, BA, AM, RS, etc.).
  3. O usuario define o cargo eletivo (Presidente, Governador, Senador, Deputado Federal, Deputado Estadual ou Distrital).
  4. Opcionalmente, aplica filtros por partido ou pesquisa por texto (nome de urna ou numero de campanha).
  5. O sistema recupera instantaneamente os dados do armazenamento local em banco Drift (< 50ms) e, paralelamente, valida se existem atualizacoes de rede junto a API do TSE.
  6. A listagem e renderizada exibindo foto oficial, nome de urna, numero, sigla partidaria, composicao de coligacao e situacao juridica.

### UC02: Ficha Detalhada e Qualificacao do Candidato
* **Ator:** Cidadao / Eleitor.
* **Pre-condicoes:** Candidato selecionado a partir da listagem.
* **Fluxo Principal:**
  1. O sistema requisita o identificador unico e exibe a qualificacao civil: nome completo, nome de urna, numero oficial, cargo, ocupacao declarada, grau de instrucao, data de nascimento e limites legais de gastos do 1º e 2º turnos.
  2. Apresenta-se o status de deferimento acompanhado de texto explicativo formal sobre recursos judiciais cabiveis ou pendentes.
  3. Apresenta-se a composicao da chapa majoritaria (vices ou suplentes de senador).

### UC03: Auditoria do Patrimonio Declarado
* **Ator:** Cidadao / Eleitor.
* **Pre-condicoes:** O usuario acessa a aba "Patrimonio" na ficha individual.
* **Fluxo Principal:**
  1. O sistema calcula o somatorio consolidado em moeda nacional (BRL).
  2. Os itens sao listados de forma discriminada com tipo oficial (imovel, veiculo, investimento, quotas), descricao informada e valor declarado.
  3. O usuario pode ordenar os bens por maior ou menor valor.

### UC04: Visualizacao de Propostas de Governo
* **Ator:** Cidadao / Eleitor.
* **Pre-condicoes:** Candidato a cargo do Poder Executivo.
* **Fluxo Principal:**
  1. O usuario acessa a secao "Diretrizes e Plano de Governo".
  2. O aplicativo disponibiliza o link de download seguro ou a visualizacao interna do arquivo oficial PDF submetido a Justica Eleitoral.

---

## 4. Requisitos Funcionais (RF)

* **RF01 - Abrangencia Territorial Nacional:** O sistema deve suportar todas as 27 Unidades Federativas do Brasil e o ambito nacional (`BR`) para eleições federais, com arquitetura preparada para o suporte a todos os 5.570 municipios brasileiros em pleitos municipais.
* **RF02 - Pesquisa Textual com Debounce:** Campo de busca textual com intervalo de espera (*debounce*) de 300 milissegundos para filtragem dinamica por nome civil, nome de urna ou numero eleitoral.
* **RF03 - Exibicao de Status Juridico Explicativo:** O sistema deve apresentar a situacao oficial do registro de candidatura (Deferido, Indeferido com recurso, Aguardando julgamento, Cancelado, Renuncia, Falecido), acompanhado de indicacao explicativa sobre eventuais recursos pendentes de julgamento definitivo.
* **RF04 - Agrupamento e Sumarizacao Patrimonial:** Calculo automatico do patrimonio global declarado com formatacao monetaria em BRL e ordenacao configuravel por valor venal.
* **RF05 - Cache Local Sob Demanda com Deteccao de Deltas:** O sistema deve persistir todas as consultas em banco relacional local (Drift/SQLite). Ao repetir uma consulta, o dado persistido deve ser renderizado imediatamente, enquanto uma verificacao em segundo plano checa cabecalhos de modificacao (`If-Modified-Since`) ou hashes de atualizacao no TSE.
* **RF06 - Exibicao de Chapa e Suplencias:** Apresentacao dos candidatos a vice-presidente, vice-governador e suplentes de senador com acesso direto as suas respectivas fichas.
* **RF07 - Acesso a Documentos Programaticos:** Disponibilizacao de links operacionais e visualizador compativel para o arquivo oficial de plano de governo em formato PDF.
* **RF08 - Tratamento Resiliente de Imagens:** Carregamento de fotos oficiais do TSE com politicas de cache em disco e tratamento defensivo para imagens ausentes ou corrompidas, provendo placeholder neutro institucional.
* **RF09 - Modo de Operacao Offline Completo:** Todas as candidaturas, detalhes e bens ja baixados pelo usuario devem permanecer totalmente navegaveis e pesquisaveis mesmo em caso de perda total de conectividade de rede.

---

## 5. Requisitos Nao-Funcionais (RNF)

* **RNF01 - Latencia de Resposta da Interface:** O tempo de resposta para listagem de candidatos servida a partir do banco local nao deve exceder 50 milissegundos (60 a 120 quadros por segundo em animacoes).
* **RNF02 - Disponibilidade e Resiliencia:** O aplicativo deve operar de forma ininterrupta mesmo durante quedas severas dos servidores centrais do TSE, servindo dados locais e sinalizando a data do ultimo instantaneo (*snapshot*).
* **RNF03 - Neutralidade Algoritmica Estrita:** A ordenacao padrao de candidaturas deve ser estritamente alfabetica pelo nome de urna ou numerica crescente por identificador partidario. E vedada qualquer forma de impulsionamento ou ranqueamento por popularidade.
* **RNF04 - Privacidade e Nao-Rastreamento (LGPD):** O aplicativo nao deve solicitar cadastro, correio eletronico, numero de telefone ou autenticacao social. Nenhum dado do dispositivo ou parametro de consulta individual deve ser transmitido para servicos de terceiros.
* **RNF05 - Acessibilidade Digital Estrita (WCAG 2.1 AA):**
  * Contraste cromatico minimo de 4,5:1 para texto normal e 3:1 para texto grande ou icones informativos.
  * Alvo de toque minimo de 48x48 dp para todos os componentes interativos.
  * Compatibilidade integral com escala de fonte do sistema operacional (`textScaler`), sem truncamento ou estouro de leiaute (*overflow*).
  * Anotacao semantica compulsoria em todos os elementos da arvore visual (`Semantics`), assegurando experiencia fluida com leitores de tela (TalkBack e VoiceOver).
* **RNF06 - Responsividade Adaptativa:** O aplicativo deve se adaptar de forma fluida a tres categorias de tela: Compacto (< 600dp - smartphones), Medio (600 a 840dp - tablets e celulares dobrados) e Expandido (> 840dp - tablets horizontais e computadores desktop).

---

## 6. Escopo do Produto Minimo Viavel (MVP)

### 6.1 Funcionalidades Integrantes do MVP
1. Modulo de selecao de Eleicao (Gerais 2026), Unidade Federativa (todas as 27 UFs + Nacional `BR`) e Cargo (Presidente, Governador, Senador, Deputado Federal, Deputado Estadual/Distrital).
2. Listagem de candidatos em grelha responsiva adaptavel, com foto em cache, numero, nome de urna, sigla do partido e situacao juridica.
3. Tela de detalhe individual com dados civis informados, composicao de coligacao, limites de gastos e relacao de bens declarados com totalizador financeiro.
4. Motor de persistencia local relacional via Drift (SQLite) com mecanismo de cache sob demanda *Stale-While-Revalidate*.
5. Suporte nativo e adaptativo aos temas claro e escuro, respeitando as configuracoes do sistema operacional.
6. Conformidade plena com acessibilidade WCAG 2.1 AA e escalabilidade tipografica dinamica.

### 6.2 Funcionalidades Pos-MVP (Fases Posteriores)
1. Modulo de comparacao lado a lado de dois ou mais candidatos em matriz analitica de propostas e historico de bens.
2. Ingestao em lote (ETL) dos arquivos consolidados CSV do Repositorio de Dados Abertos do TSE.
3. Comparacao historica de evolucao patrimonial abrangendo pleitos de 2004 a 2024.
4. Analise de concentracao de despesas e maiores doadores com visualizacao em graficos vetoriais interativos acessiveis.
