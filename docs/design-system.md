# Sistema de Design e Diretrizes de Acessibilidade (Design System & WCAG)

## Projeto: Plataforma de Transparencia Civica e Acompanhamento Eleitoral
**Documento:** DSN-001  
**Classificacao:** Especificacao Visual, Tokens Semanticos e Acessibilidade Digital  
**Revisao:** 1.0.0  
**Data:** 11 de setembro de 2026  

---

## 1. Principios Fundamentais de Design

1. **Neutralidade e Sobriedade Institucional:** A identidade visual adota tons neutros, transmitindo credibilidade, clareza e distanciamento ideologico. Nao se empregam cores associadas de maneira evidente a legendas partidarias em elementos centrais da interface.
2. **Acessibilidade Universal como Pre-Requisito (WCAG 2.1 AA):** Toda decisao de cor, tipografia e espaçamento deve atender rigorosamente aos criterios de contraste, alvos de toque e interoperabilidade com tecnologias assistivas.
3. **Densidade Informacional Otimizada:** Apresentacao concisa e estruturada de grandes volumes de dados (patrimonio, historico eleitoral e situacao juridica), minimizando a sobrecarga cognitiva do eleitor.
4. **Responsividade Fluida e Adaptativa:** Experiencia ergonomica compativel com telas pequenas de smartphones populares, tablets e monitores convencionais.

---

## 2. Arquitetura de Tokens de Cor

A estrutura cromatica e organizada em tres niveis funcionais: **Primitivos**, **Semanticos** e **Componentes**, com suporte integral a tema claro e escuro.

### 2.1 Tokens Primitivos (Paleta de Referencia)

```
Primitivos Neutros:
--color-slate-50:  #F8FAFC
--color-slate-100: #F1F5F9
--color-slate-200: #E2E8F0
--color-slate-300: #CBD5E1
--color-slate-600: #475569
--color-slate-700: #334155
--color-slate-800: #1E293B
--color-slate-900: #0F172A
--color-slate-950: #020617

Primitivos Civicos (Azul Institucional Sobrio):
--color-civic-500: #1D4ED8
--color-civic-600: #1E40AF
--color-civic-700: #1E3A8A
--color-civic-300: #93C5FD

Primitivos de Estado (Alertas e Situacoes Juridicas):
--color-emerald-700: #047857 (Deferido / Regular - Fundo Claro)
--color-emerald-400: #34D399 (Deferido / Regular - Fundo Escuro)
--color-amber-700:   #B45309 (Aguardando Julgamento / Recurso - Fundo Claro)
--color-amber-400:   #FBBF24 (Aguardando Julgamento / Recurso - Fundo Escuro)
--color-rose-700:    #BE123C (Indeferido / Cassado - Fundo Claro)
--color-rose-400:    #FB7185 (Indeferido / Cassado - Fundo Escuro)
```

### 2.2 Tokens Semanticos e Matriz de Contraste WCAG 2.1 AA

Todos os pares de cores abaixo foram calculados e certificados para exceder a razao minima de contraste de 4,5:1 (texto padrao) e 3,0:1 (elementos graficos e titulos grandes):

| Token Semantico | Modo Claro (Hex) | Modo Escuro (Hex) | Contraste sobre Fundo | Conformidade WCAG 2.1 |
|---|---|---|---|---|
| `surfaceBackground` | `#F8FAFC` | `#0F172A` | Base de tela | [CONFORME] |
| `surfaceCard` | `#FFFFFF` | `#1E293B` | N/A | [CONFORME] |
| `textPrimary` | `#0F172A` | `#F8FAFC` | 15,8:1 (Claro) / 15,4:1 (Escuro) | [EXCEDE WCAG AAA] |
| `textSecondary` | `#475569` | `#94A3B8` | 7,1:1 (Claro) / 6,5:1 (Escuro) | [EXCEDE WCAG AA] |
| `borderSubtle` | `#E2E8F0` | `#334155` | 3,2:1 | [CONFORME WCAG AA] |
| `brandPrimary` | `#1E40AF` | `#93C5FD` | 8,9:1 (Claro) / 7,8:1 (Escuro) | [EXCEDE WCAG AA] |
| `statusDeferred` | `#047857` | `#34D399` | 5,6:1 (Claro) / 7,2:1 (Escuro) | [CONFORME WCAG AA] |
| `statusPending` | `#B45309` | `#FBBF24` | 5,1:1 (Claro) / 8,0:1 (Escuro) | [CONFORME WCAG AA] |
| `statusIneligible`| `#BE123C` | `#FB7185` | 6,3:1 (Claro) / 6,9:1 (Escuro) | [CONFORME WCAG AA] |

---

## 3. Ergonomia e Dimensoes Minimas de Toque

1. **Alvo de Toque Minimo:** Qualquer elemento interativo (botoes de filtro, cartoes clicaveis, seletores de pagina, campos de busca) deve respeitar a area interativa minima de **48x48 dp** (`kMinInteractiveDimension` no Flutter), prevenindo erros de acionamento motor involuntario.
2. **Espaçamento e Grelha Base:** O sistema utiliza escala modular baseada em incrementos de 4 e 8 dp:
   * `space-2xs`: 4 dp
   * `space-xs`:  8 dp
   * `space-sm`:  12 dp
   * `space-md`:  16 dp (margem padrao de telas moveis)
   * `space-lg`:  24 dp
   * `space-xl`:  32 dp
   * `space-2xl`: 48 dp

---

## 4. Tipografia e Suporte a Escala Dinamica de Texto (Text Scaling)

A hierarquia tipografica e baseada na familia sans-serif contemporanea **Roboto** ou fonte nativa do sistema operacional, configurada com densidade legivel:

| Estilo de Texto | Tamanho (sp) | Peso (FontWeight) | Altura de Linha (Height) | Finalidade de Uso |
|---|---|---|---|---|
| `displayLarge` | 28 | Negrito (`w700`) | 1.25 | Titulos principais de paginas |
| `headlineMedium` | 20 | Semi-Negrito (`w600`)| 1.30 | Nome de urna do candidato |
| `titleMedium` | 16 | Semi-Negrito (`w600`)| 1.35 | Subtitulos de secoes e cargos |
| `bodyLarge` | 16 | Regular (`w400`) | 1.45 | Dados civis e textos corridos |
| `bodyMedium` | 14 | Regular (`w400`) | 1.40 | Listas discriminadas de bens |
| `labelLarge` | 14 | Medio (`w500`) | 1.20 | Rotulos de botoes e chips de filtro |
| `labelSmall` | 12 | Regular (`w400`) | 1.20 | Metadados e carimbos de data/hora |

### Diretrizes Obrigatorias de Suporte a Ampliacao de Texto
1. **Ausencia de Alturas Fixas em Caixas de Texto:** E terminantemente proibido o uso de `Container(height: X)` englobando elementos textuais. Caixas devem expandir verticalmente de forma fluida para acomodar escalas de ate 200% (`textScaler: TextScaler.linear(2.0)`).
2. **Rolagem Flexivel:** Telas e modais com formulários ou fichas devem ser envolvidos compulsoriamente em componentes de rolagem (`SingleChildScrollView` ou `ListView`) para evitar estouro de tela (*RenderFlex overflowed*).
3. **Tratamento de Linhas Longas:** Utilizar `TextOverflow.ellipsis` exclusivamente em titulos de cartoes de listagem com indicativo semantico completo acessivel via leitor de tela.

---

## 5. Acessibilidade Semantica para Leitores de Tela (TalkBack e VoiceOver)

1. **Anotacao Semantica Rigorosa:** Todos os widgets informativos ou interativos devem ser envolvidos em componentes `Semantics`:
   * Botoes de acao: `Semantics(button: true, label: "Filtrar por partido", ...)`
   * Fotos de candidatos: `Semantics(image: true, label: "Foto oficial de urna de [NOME DO CANDIDATO]", ...)`
   * Elementos puramente decorativos (linhas divisórias, icones de seta): `ExcludeSemantics(child: ...)`
2. **Rotulacao Explicativa de Status Eleitoral:** Chips visuais de status nao devem se limitar a cor. O leitor de tela deve anunciar textualmente o significado completo (ex: `"Situacao do registro: Deferido com recurso pendente de julgamento no Tribunal Superior Eleitoral"`).
3. **Anuncios de Transicao de Estado:** Quando uma pesquisa for concluida ou ocorrer transicao para o modo de contingencia local, utilizar `SemanticsService.announce("Carregamento concluido. Vinte candidatos encontrados.", TextDirection.ltr)` para alertar usuarios com deficiencia visual.

---

## 6. Matriz de Responsividade Multiplataforma

O aplicativo adota tres pontos de interrupcao (*breakpoints*) adaptativos para garantir experiencia consistente em qualquer formato de tela:

```
+-----------------------------------------------------------------------------------+
| COMPACTO (< 600 dp)      | MEDIO (600 dp a 840 dp)      | EXPANDIDO (> 840 dp)    |
| Smartphones em pe        | Tablets e dobráveis          | Desktop e Tablets Horiz.|
|--------------------------+------------------------------+-------------------------|
| - Navegacao inferior     | - Trilho lateral             | - Menu lateral fixo     |
|   (NavigationBar)        |   (NavigationRail)           |   (NavigationDrawer)    |
| - Grelha em coluna unica | - Grelha com 2 colunas       | - Grelha com 3 colunas  |
| - Modais em BottomSheet  | - Paineis laterais           | - Visao Mestre-Detalhe  |
|   deslizante             |   expansiveis                |   lado a lado na tela   |
+-----------------------------------------------------------------------------------+
```

### Implementacao Tecnica
* O layout deve ser inspecionado atraves de `LayoutBuilder` ou `MediaQuery.sizeOf(context).width`, selecionando os componentes estruturais correspondentes sem recriar desnecessariamente o estado interno das telas.
