---
name: ui-ux-pro
description: >-
  Inteligencia de design UI/UX, tokens semanticos, componentes acessiveis
  e diretrizes WCAG 2.1 AA especializadas para interfaces em Flutter.
---

# Skill: UI/UX Pro para Flutter

Esta skill orienta o agente na concepcao, estilizacao e implementacao de interfaces de usuario profissionais, acessiveis e de alto impacto visual em Flutter, evitando padroes genericos e assegurando conformidade estrita com normas de acessibilidade e design de sistemas.

---

## 1. Quando Ativar Esta Skill

* Definicao e refatoracao de tokens de design e temas claro e escuro.
* Criacao de componentes de interface que requerem alta densidade informacional (tabelas, cartoes com metadados, visualizadores patrimoniais).
* Auditoria de conformidade de acessibilidade (WCAG 2.1 AA, contraste cromatico e alvos de toque).
* Adaptacao de telas para multiplas resolucoes (breakpoints compacto, medio e expandido).
* Configuracao de semantica e rotulacao para tecnologias assistivas (leitores de tela).

---

## 2. Estrutura de Tokens em Tres Camadas

Toda construcao visual deve respeitar a separacao hierarquica:

1. **Tokens Primitivos:** Cores e dimensoes puras em valor absoluto (ex: `slate900 = Color(0xFF0F172A)`).
2. **Tokens Semanticos:** Papeis conceituais independentes do modo de cor (ex: `surfaceBackground`, `textPrimary`, `statusDeferred`).
3. **Tokens de Componente:** Propriedades especificas do widget (ex: `candidateCardBorderColor`, `filterChipElevation`).

---

## 3. Checklist de Design e Acessibilidade (WCAG 2.1 AA)

Antes de concluir qualquer widget ou tela visual, validar compulsoriamente os seguintes itens:

* [ ] **Contraste de Texto Normal (mínimo 4,5:1):** Textos abaixo de 18pt possuem contraste certificado sobre a superficie de fundo.
* [ ] **Contraste de Texto Grande ou Icones (mínimo 3:1):** Titulos em destaque e iconografia informativa possuem contraste minimo de 3:1.
* [ ] **Alvo de Toque Minimo (48x48 dp):** Botoes, icones clicaveis e campos interativos respeitam o limite ergonomico (`kMinInteractiveDimension`).
* [ ] **Suporte a Escala Tipografica:** O componente foi testado com `textScaler` ampliado sem apresentar quebras de leiaute (*overflow*).
* [ ] **Anotacao Semantica:** Elementos interativos e imagens possuem rotulos textuais explicativos via widget `Semantics`.
* [ ] **Exclusao de Elementos Decorativos:** Separadores e icones redundantes utilizam `ExcludeSemantics`.
* [ ] **Densidade e Espacamento:** A tela obedece a grelha de 8 dp para margens e preenchimentos.
* [ ] **Responsividade:** O leiaute reorganiza colunas e navegacao conforme os breakpoints (<600dp, 600-840dp, >840dp).
