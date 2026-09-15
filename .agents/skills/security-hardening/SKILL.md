---
name: security-hardening
description: >-
  Protocolo de DevSecOps, auditoria de seguranca da informacao e hardening
  de infraestrutura para o projeto civico Quem Votar. Abrange configuracoes de Nginx,
  protecao de borda, seguranca em Docker/VM Linux, auditoria de dependencias e
  conformidade com a LGPD sem utilizacao de emojis.
---

# Skill: Seguranca da Informacao, Hardening e Auditoria de Producao (Quem Votar)

Esta skill estabelece os padroes obrigatorios de seguranca, auditoria de vulnerabilidades e endurecimento (*hardening*) de sistemas para o ambiente computacional do projeto civico *Quem Votar*.

---

## 1. Principios Fundamentais de Seguranca da Plataforma

1. **Arquitetura Estritamente Stateless (Sem Contas de Usuario):**
   * A plataforma nao implementa autenticacao, sessoes, cadastro de eleitores ou armazenamento de credenciais.
   * Consequencia: eliminacao estrutural de vetores de ataque como sequestro de sessao (*session hijacking*), vazamento de senhas, injeccao SQL em bases de usuarios e exposicao de dados pessoais.

2. **Minimizacao de Dados e Conformidade com a LGPD (Lei nº 13.709/2018):**
   * Nenhum dado de telemetria, IP identificavel, impressao digital de navegador (*canvas fingerprinting*) ou cookie de rastreamento deve ser coletado ou persistido.
   * Os unicos dados trafegados sao informacoes publicas e oficiais de candidaturas chanceladas pela Justica Eleitoral.

3. **Neutralidade Algoritmica Estrita:**
   * Nenhuma logica de ordenacao ou filtro pode favorecer partidos ou espectros politicos. O sistema deve refletir fidedignamente o repositorio oficial do TSE.

---

## 2. Hardening da Camada de Servico Web e Micro-Proxy (Nginx)

### 2.1. Cabecalhos de Seguranca HTTP Obrigatorios
No bloco `server` do [deploy/nginx.conf](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/deploy/nginx.conf), devem constar os seguintes cabecalhos defensivos:

```nginx
# Prevencao contra Clickjacking
add_header X-Frame-Options "SAMEORIGIN" always;

# Prevencao contra MIME-Sniffing
add_header X-Content-Type-Options "nosniff" always;

# Politica de Referenciador Estrita
add_header Referrer-Policy "strict-origin-when-cross-origin" always;

# Politica de Protecao de Conteudo (Content Security Policy)
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'wasm-unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob: https://divulgacandcontas.tse.jus.br; font-src 'self' data:; connect-src 'self' https://divulgacandcontas.tse.jus.br; object-src 'none'; frame-ancestors 'self';" always;

# Forcamento de HTTPS estrito (HSTS) - 1 ano
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
```

### 2.2. Limitacao de Taxa (Rate Limiting) contra Abusos
Para impedir ataques de negação de serviço (DoS) e scraping desenfreado sobre o micro-proxy:

```nginx
# Declaracao no bloco http:
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=30r/s;

# Aplicacao no location /quemvotar/api/:
location /quemvotar/api/ {
    limit_req zone=api_limit burst=50 nodelay;
    ...
}
```

---

## 3. Hardening da Maquina Virtual (VM Linux / Contabo)

### 3.1. Firewall de Borda UFW (Uncomplicated Firewall)
Apenas as portas estritamente necessarias devem estar acessiveis ao trafego externo:

```bash
# Politica padrao: rejeitar todo o trafego de entrada
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Liberacao restrita: Web (HTTP/HTTPS)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# SSH restrito (recomenda-se porta alta alterada ou restricao por IP de origem)
sudo ufw allow 22/tcp

# Ativacao e inspecao de status
sudo ufw enable
sudo ufw status verbose
```

### 3.2. Gerencia de SSH e Prevencao de Forca Bruta
1. Autenticacao restrita exclusivamente a chaves publicas modernas (`Ed25519`).
2. Desativacao compulsoria de login por senha (`PasswordAuthentication no`) e login direto de `root` (`PermitRootLogin no`) em `/etc/ssh/sshd_config`.
3. Instalacao e ativacao de `fail2ban` monitorando tentativas excessivas de conexao SSH.

### 3.3. Protecao Perimetral via Cloudflare
1. Redirecionar os registros de DNS de `todeolho.org` atraves do Proxy Cloudflare (nuvem laranja ativada).
2. Beneficios operacionais:
   * Ocultacao completa do endereco IP publico da VM Contabo;
   * Absorcao de ataques volumetricos de DDoS nas camadas 3, 4 e 7;
   * Distribuicao de arquivos compilados estaticos em rede CDN geograficamente distribuida;
   * Certificados SSL de borda gerenciados automaticamente.

---

## 4. Seguranca de Conteineres Docker

1. **Sistemas de Arquivos em Somente Leitura:**
   * Os volumes montados em [deploy/docker-compose.yml](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/deploy/docker-compose.yml) devem usar o modificador `:ro` para codigo e configuracoes (`./web:/usr/share/nginx/html:ro`).
   * Apenas pastas de cache temporario (`cache_data:/var/cache/nginx`) devem permitir escrita.
2. **Descarte de Capacidades Linux Desnecessarias:**
   * Incluir `cap_drop: [ALL]` e adicionar apenas `cap_add: [NET_BIND_SERVICE]` nos servicos de borda.
3. **Isolamento de Redes:**
   * Manter a rede `proxy_default` isolada sem exposicao publica desnecessaria de portas internas do micro-proxy (porta 3000 mantida restrita internamente a rede do Docker).

---

## 5. Auditoria de Dependencias e Analise Estatica de Codigo

Toda versao liberada para producao deve ser submetida as seguintes verificacoes no terminal:

```powershell
# 1. Analise estatica estrita de linter Dart/Flutter
flutter analyze

# 2. Inspecao de dependencias vulneraveis ou obsoletas do Flutter
flutter pub outdated

# 3. Auditoria de seguranca das dependencias do micro-proxy Node.js (se aplicavel)
npm audit --omit=dev

# 4. Inspecao de seguranca do Dockerfile e Nginx
docker run --rm -i hadolint/hadolint < deploy/Dockerfile
```

---

## 6. Procedimento Operacional em Caso de Alerta de Seguranca

Caso uma vulnerabilidade de severidade alta ou critica seja detectada em pacote de terceiros:
1. Executar `flutter pub upgrade <nome_do_pacote>` ou atualizar manualmente no [pubspec.yaml](file:///c:/Users/pedro/OneDrive/Documentos/projetos/quem-votar/pubspec.yaml).
2. Validar a suite completa de testes automatizados: `flutter test --no-pub`.
3. Recompilar o binario web: `flutter build web --release --base-href /quemvotar/`.
4. Atualizar o servico em producao via script de deploy automatizado.
