# Infraestrutura, Roteamento Web e Implantacao em Servidor Dedicado

## Projeto: Plataforma de Transparencia Civica e Acompanhamento Eleitoral
**Documento:** INF-001  
**Classificacao:** Especificacao de Infraestrutura e Implantacao (DevOps)  
**Revisao:** 1.0.0  
**Data:** 13 de setembro de 2026  

---

## 1. Visao Geral e Topologia de Hospedagem

Este documento estabelece as diretrizes de engenharia de infraestrutura, roteamento perimetral e implantacao continua para a disponibilizacao publica da versao Web do aplicativo civico *Quem Votar*.

O cenario operacional contempla o compartilhamento de recursos computacionais em uma mesma Maquina Virtual (VM) hospedada no provedor Contabo, convivendo de forma isolada com aplicacoes preexistentes.

### 1.1 Parametros da Infraestrutura

* **Provedor:** Contabo VPS
* **Endereco IP Publico (IPv4):** `13.140.190.55`
* **Dominio Preexistente:** `neurofluxis.com` (operacao preservada e inalterada)
* **Novo Dominio Vinculado:** `todeolho.org`
* **Destino do Aplicativo:** `todeolho.org/quemvotar` (ou alternativamente `quemvotar.todeolho.org`)
* **Servidor Web e Proxy Reverso:** Nginx (ou Caddy) sobre distribuicao Linux (Ubuntu/Debian)
* **Mecanismo de Seguranca de Transporte:** TLS 1.3 via certificados Let's Encrypt

---

## 2. Principios de Rede e Roteamento Multidominio

A coexistencia de multiplos dominios e aplicacoes sob um unico endereco IP publico fundamenta-se em dois padroes estabelecidos da arquitetura Internet:

```
[Cliente HTTP / Navegador]
            |
            | Requisicao HTTPS (Host: todeolho.org | SNI: todeolho.org)
            v
[IP Publico: 13.140.190.55]
            |
      +-----+--------------------------------------+
      | Nginx (Roteador Perimetral / Reverse Proxy)|
      +-----+--------------------------------------+
            |
            +---> server_name neurofluxis.com -> [Aplicacao Neurofluxis]
            |
            +---> server_name todeolho.org
                     |
                     +---> location /          -> [Portal Institucional /var/www/todeolho]
                     |
                     +---> location /quemvotar -> [Flutter Web SPA /var/www/quemvotar/web]
```

### 2.1 Server Name Indication (SNI)
O protocolo SNI (extensao do TLS descrita na RFC 6066) viabiliza que o cliente envie o nome de dominio qualificado (FQDN) durante o aperto de mao criptografico inicial (*TLS Handshake*). Dessa forma, a camada perimetral seleciona e entrega o certificado digital correto de `todeolho.org`, mantendo a emissao e as chaves privadas de `neurofluxis.com` totalmente segregadas.

### 2.2 Cabecalho HTTP `Host`
Apos o estabelecimento do tunel criptografico seguro, a camada de aplicacao inspeciona o cabecalho HTTP `Host: todeolho.org`. O servidor web distribui a carga interna para o respectivo bloco de configuracao (*Virtual Host*), sem cruzamento de trafego entre projetos distintos.

---

## 3. Avaliacao Comparativa de Estrategias de URI

| Criterio | Subcaminho (`todeolho.org/quemvotar`) | Subdominio (`quemvotar.todeolho.org`) |
|---|---|---|
| **Autoridade de Dominio (SEO)** | Concentrada integralmente no dominio raiz `todeolho.org`. | Segmentada pelo motor de busca como entidade isolada. |
| **Complexidade de Nginx** | Moderada: exige diretivas `alias` e reescrita de caminhos para SPA. | Baixa: bloco `server` independente apontando para a raiz `/`. |
| **Compilacao Flutter Web** | Requer parametro compulsorio `--base-href "/quemvotar/"`. | Compilacao padrao sem necessidade de modificacao (`--base-href "/"`). |
| **Isolamento de Cookies/Storage** | Origem compartilhada com `todeolho.org` (exige atencao a conflitos de chave). | Origem isolada por subdominio no navegador (*Same-Origin Policy*). |
| **Certificado Digital** | Cobre o mesmo certificado SAN emitido para `todeolho.org`. | Exige inclusao do subdominio no certificado Let's Encrypt ou Wildcard. |

---

## 4. Configuracao da Zona DNS

No painel administrativo da entidade registradora de `todeolho.org` (ex: Registro.br, Cloudflare ou Route53), devem ser inseridas as seguintes entradas de resolucao de nomes:

```dns
; Zona DNS para todeolho.org
@       IN  A       13.140.190.55       ; Apontamento do dominio raiz
www     IN  CNAME   todeolho.org.       ; Alias canonico para www
; Caso seja adotada a estrategia de subdominio:
quemvotar IN A      13.140.190.55       ; Apontamento dedicado
```

*Nota: O tempo de propagacao das zonas DNS varia de 15 minutos a 24 horas a depender das configuracoes de TTL (Time to Live).*

---

## 5. Compilacao do Cliente Flutter Web para Subdiretorios

Aplicacoes Single Page Application (SPA) compiladas em Flutter constroem por definicao seus links para carregamento de scripts (`main.dart.js`, `flutter.js`), fontes e icones a partir do caminho raiz (`/`). Para execucao sob o subcaminho `/quemvotar/`, e compulsorio injetar a base relativa de resolucao de URI durante a etapa de construcao de artefatos.

### 5.1 Comando de Build de Producao

Executar o seguinte comando no terminal do ambiente de desenvolvimento:

```powershell
flutter build web --release --base-href "/quemvotar/"
```

### 5.2 Estrutura do Pacote Gerado (`build/web/`)

```
build/web/
├── assets/                   # Imagens, fontes e dados empacotados
├── canvaskit/                # Binarios WebAssembly do Skia (se aplicavel)
├── flutter.js                # Bootstrap de inicializacao do Flutter Engine
├── flutter_bootstrap.js      # Script de orquestracao da carga de runtime
├── flutter_service_worker.js # Cache offline e service worker
├── index.html                # Ponto de entrada com tag <base href="/quemvotar/">
├── main.dart.js              # Codigo compilado da aplicacao
├── manifest.json             # Manifesto PWA
└── version.json              # Identificacao de versao
```

---

## 6. Configuracao do Servidor Web (Nginx)

Na maquina virtual Linux (`13.140.190.55`), a configuracao deve ser particionada em arquivos modulares em `/etc/nginx/sites-available/` e ativada via links simbolicos em `/etc/nginx/sites-enabled/`.

### 6.1 Estrutura de Diretorios no Servidor

```bash
sudo mkdir -p /var/www/todeolho/main
sudo mkdir -p /var/www/quemvotar/web
sudo chown -R www-data:www-data /var/www/todeolho /var/www/quemvotar
sudo chmod -R 755 /var/www
```

### 6.2 Bloco de Servidor para `todeolho.org` (`/etc/nginx/sites-available/todeolho.org`)

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name todeolho.org www.todeolho.org;

    # Redirecionamento forçado para canal seguro HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name todeolho.org www.todeolho.org;

    # Parametros de certificados SSL (preenchidos automaticamente pelo Certbot)
    ssl_certificate /etc/letsencrypt/live/todeolho.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/todeolho.org/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Cabecalhos de seguranca HTTP
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # Compressao de dados para transferencia veloz
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/json application/xml+rss image/svg+xml;

    # 1. Aplicacao principal / portal de entrada
    location / {
        root /var/www/todeolho/main;
        index index.html index.htm;
        try_files $uri $uri/ =404;
    }

    # 2. Aplicacao civica Quem Votar (Subcaminho)
    location ^~ /quemvotar {
        alias /var/www/quemvotar/web;
        index index.html;

        # Roteamento SPA: Qualquer rota interna (ex: /quemvotar/candidato/123)
        # que nao corresponda a um arquivo estatico existente deve carregar o index.html
        try_files $uri $uri/ /quemvotar/index.html;

        # Cache imutavel de longo prazo para binarios versionados do Flutter
        location ~* \.(js|css|wasm|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
            expires 1y;
            add_header Cache-Control "public, no-transform, immutable";
        }

        # Desabilitar cache para arquivos de bootstrap e manifest para garantir atualizacoes
        location ~* \.(json|html)$ {
            expires -1;
            add_header Cache-Control "no-store, no-cache, must-revalidate, post-check=0, pre-check=0";
        }
    }
}
```

### 6.3 Validacao e Aplicacao

```bash
# Validacao sintatica do Nginx sem interrupcao do servico
sudo nginx -t

# Recarregamento gracioso da configuracao
sudo systemctl reload nginx
```

---

## 7. Emissao de Certificados Criptograficos (SSL/TLS)

A geracao de certificados digitais validos para navegadores contemporaneos e conduzida de modo automatizado via Certbot contra os servidores da autoridade certificadora Let's Encrypt:

```bash
# Instalacao do Certbot e modulo Nginx (caso nao existam)
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx

# Emissao independente para o novo dominio sem alterar certificados de neurofluxis.com
sudo certbot --nginx -d todeolho.org -d www.todeolho.org
```

O utilitário cria automaticamente as tarefas cron em `/etc/cron.d/certbot` para renovacao periodica antes do prazo limite de 90 dias.

---

## 8. Pipeline de Deploy Manual via SSH e Rsync

Para remeter a versao compilada do ambiente de desenvolvimento local (PowerShell no Windows) para o servidor Contabo de forma segura e idempotente:

```powershell
# 1. Compilar os artefatos com o base-href ajustado
flutter build web --release --base-href "/quemvotar/"

# 2. Sincronizar os arquivos para o servidor via rsync / scp
# Substitua 'usuario' pelo usuario administrativo com privilegios na VM
scp -r build/web/* usuario@13.140.190.55:/var/www/quemvotar/web/

# 3. Ajustar permissoes de leitura para o processo do Nginx
ssh usuario@13.140.190.55 "sudo chown -R www-data:www-data /var/www/quemvotar/web && sudo chmod -R 755 /var/www/quemvotar/web"
```

---

## 9. Plano de Contingencia e Solucao de Incidentes Comuns

### 9.1 Falha 404 ao Recarregar Rotas Internas no Navegador (F5)
* **Causa:** O servidor web tenta localizar fisicamente o arquivo no caminho da rota interna (ex: `/var/www/quemvotar/web/candidato/2026/BR`).
* **Correcao:** Verificar se a diretiva `try_files $uri $uri/ /quemvotar/index.html;` esta declarada corretamente no bloco `location ^~ /quemvotar`.

### 9.2 Tela Branca com Erro 404 para `main.dart.js` no Console
* **Causa:** O Flutter Web foi compilado sem a especificacao de `--base-href "/quemvotar/"`.
* **Correcao:** Recompilar o binario incluindo o parametro de base e retransmitir os arquivos estaticos.

### 9.3 Erro de Permissao `403 Forbidden`
* **Causa:** O usuario sob o qual roda o processo Nginx (`www-data`) nao possui privilegios de leitura nos arquivos ou de execucao nas pastas pai.
* **Correcao:** Executar `sudo chown -R www-data:www-data /var/www/quemvotar/web` e `sudo chmod -R 755 /var/www/quemvotar/web`.
