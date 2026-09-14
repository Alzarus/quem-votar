# Infraestrutura, Roteamento Web e Implantacao em Servidor Dedicado

## Projeto: Plataforma de Transparencia Civica e Acompanhamento Eleitoral
**Documento:** INF-001  
**Classificacao:** Especificacao de Infraestrutura, DevOps e Borda de Cache  
**Revisao:** 2.0.0  
**Data:** 13 de setembro de 2026  
**Nota de Revisao:** Documento alinhado com a topologia real da Maquina Virtual Contabo inspecionada via SSH. Integracao via Docker Compose, orquestracao de borda via Nginx Proxy Manager (NPM) na rede `proxy_default`, coexistencia com `neuroanalises` (`neurofluxis.com`) e implementacao do Micro-Proxy de Cache para contorno de CORS e Akamai do TSE.

---

## 1. Topologia Real da Infraestrutura da Maquina Virtual (VM)

A infraestrutura de producao e hospedada em uma Maquina Virtual (VM) no provedor Contabo, sob o sistema operacional Ubuntu Linux. Todos os servicos em execucao sao isolados em containers Docker gerenciados por Docker Compose, conectados atraves de uma rede interna bridge compartilhada denominada `proxy_default`.

### 1.1 Parametros Globais do Servidor

* **Provedor:** Contabo VPS
* **Endereco IP Publico (IPv4):** `13.140.190.55`
* **Roteador Perimetral e Gerenciador SSL:** Nginx Proxy Manager (NPM) (`jc21/nginx-proxy-manager:latest`) localizado em `/opt/proxy`
* **Rede Interna Docker:** `proxy_default` (rede bridge compartilhada)
* **Portas de Borda Publicas:**
  * `80/tcp` (HTTP) -> Redirecionamento compulsorio para HTTPS
  * `443/tcp` (HTTPS / HTTP2) -> Terminacao TLS com certificados Let's Encrypt automatizados
  * `127.0.0.1:81` (Painel Administrativo Web do NPM restrito ao loopback local)

### 1.2 Mapeamento de Dominios e Coexistencia de Projetos

A maquina virtual hospeda simultaneamente aplicacoes com dominios e finalidades independentes:

| Dominio FQDN | Caminho / Rota | Servico de Destino | Container / Porta Interna | Finalidade / Status |
|---|---|---|---|---|
| `neurofluxis.com` | `/` (redireciona para `/neuroanalises/`) | Aplicacao Neuroanalises | `neuroanalises-app:5333` | Em operacao ativa |
| `todeolho.org` | `/` | Portal Institucional To de Olho | A definir (estatico ou app) | Planejado para configuracao futura |
| `todeolho.org` | `/quemvotar/` | Aplicacao Civica Quem Votar | `quemvotar-web:8080` | Flutter Web SPA compilado em Nginx Alpine |
| `todeolho.org` | `/quemvotar/api/` | Micro-Proxy e Cache do TSE | `quemvotar-web:8080/api/` | Proxy reverso com micro-cache em disco (15 min) |

---

## 2. O Desafio do CORS e a Solucao de Borda na VM

### 2.1 A Restricao de CORS no Ambiente do Navegador (Flutter Web)
Quando o aplicativo e executado no navegador do usuario como Single Page Application (SPA), as solicitacoes HTTP disparadas pelo motor JavaScript para o dominio do Tribunal Superior Eleitoral (`divulgacandcontas.tse.jus.br`) sofrem duas restricoes irreversiveis do lado do cliente:
1. **Politica de Mesma Origem (Same-Origin Policy / CORS):** O servidor do TSE nao envia o cabecalho `Access-Control-Allow-Origin: *`, fazendo com que o navegador bloqueie a leitura das respostas JSON.
2. **Restricao de Cabecalhos Proibidos pelo W3C:** No navegador, o JavaScript e terminantemente impedido de sobrescrever os cabecalhos `User-Agent`, `Referer` e `Origin`. Como a infraestrutura Akamai do TSE exige tais cabecalhos para permitir o trafego, qualquer requisicao direta do browser recebe resposta de erro `HTTP 403 Forbidden`.

### 2.2 Arquitetura de Borda com Micro-Cache e Proxy Reverso
Para superar o bloqueio de CORS, contornar as restricoes do Akamai e garantir escalabilidade nacional sem sobrecarregar a infraestrutura governamental, a VM Contabo atua como **borda de aceleracao e proxy reverso**:

```
[ Navegador do Eleitor (Cidadao) ]
               |
               | HTTPS: GET /quemvotar/api/v1/candidatura/listar/...
               v
+--------------------------------------------------------------------------------+
| MAQUINA VIRTUAL CONTABO (13.140.190.55)                                        |
|                                                                                |
|  +--------------------------------------------------------------------------+  |
|  | NGINX PROXY MANAGER (NPM) (/opt/proxy)                                   |  |
|  | - Escuta em 0.0.0.0:80 e 0.0.0.0:443                                     |  |
|  | - Certificado SSL Let's Encrypt para todeolho.org                        |  |
|  | - Encaminha /quemvotar para rede docker: http://quemvotar-web:8080       |  |
|  +-------------------------------------+------------------------------------+  |
|                                        | Rede Docker: proxy_default            |
|                                        v                                       |
|  +--------------------------------------------------------------------------+  |
|  | CONTAINER: quemvotar-web (/opt/quemvotar)                                |  |
|  | Imagem: nginx:alpine-slim                                                |  |
|  |                                                                          |  |
|  | [Modulo 1: Servidor Estatico SPA]                                        |  |
|  | - Serve arquivos HTML, JS, CSS, WASM compilados do Flutter Web           |  |
|  | - Regras de roteamento SPA com fallback: try_files $uri /index.html      |  |
|  | - Cache estatico imutavel (1 ano para binarios com hash)                 |  |
|  |                                                                          |  |
|  | [Modulo 2: Micro-Proxy de Borda e Cache do TSE]                          |  |
|  | - Intercepta requisicoes em /quemvotar/api/                              |  |
|  | - Injeta cabecalhos Akamai legitimos (Referer, User-Agent, Origin)       |  |
|  | - Micro-Cache relacional em disco com validade de 15 minutos             |  |
|  | - Headers de CORS liberados: Access-Control-Allow-Origin: *              |  |
|  +-------------------------------------+------------------------------------+  |
+----------------------------------------|---------------------------------------+
                                         | Requisicao HTTP 1.1 Direta (1 a cada 15 min)
                                         v
              +-----------------------------------------------------+
              | TRIBUNAL SUPERIOR ELEITORAL (divulgacandcontas)     |
              | Host: divulgacandcontas.tse.jus.br                  |
              +-----------------------------------------------------+
```

### 2.3 Escalabilidade Nacional e Absorcao de Carga
* **Pico Massivo de Consultas:** Caso 500.000 eleitores solicitem a lista de candidatos a Presidente simultaneamente durante o periodo eleitoral, o container `quemvotar-web` dispara **apenas uma unica requisicao** para a API do TSE a cada 15 minutos.
* **Latencia de Resposta:** As outras 499.999 requisicoes sao atendidas diretamente pelo cache de disco/memoria da VM em menos de 2 milissegundos, com consumo insignificante de processador e memoria RAM na VM Contabo.
* **Imunidade a Quedas Governamentais:** Se o servidor central do TSE ficar inoperante ou retornar erros `502/503/504`, a diretiva `proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;` instrui o Nginx a entregar o ultimo dado salvo valido para os eleitores, sem qualquer interrupcao no servico.

---

## 3. Especificacao Tecnica do Container `quemvotar-web`

O servico sera estruturado no diretorio `/opt/quemvotar` na VM Contabo, em perfeita harmonia com o padrao adotado por `/opt/neuroanalises` e `/opt/proxy`.

### 3.1 Estrutura de Arquivos em `/opt/quemvotar`

```
/opt/quemvotar/
├── docker-compose.yml        # Orquestracao do servico e vinculo com a rede proxy_default
├── nginx.conf                # Configuracao do servidor web, SPA e proxy de cache
├── Dockerfile                # Montagem da imagem Nginx Alpine com os estaticos
└── web/                      # Artefatos compilados pelo comando 'flutter build web'
```

### 3.2 Arquivo `docker-compose.yml` (`/opt/quemvotar/docker-compose.yml`)

```yaml
services:
  quemvotar-web:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: quemvotar-web
    restart: unless-stopped
    ports:
      # Exposto no loopback para validacao interna ou diagnostico direto
      - "127.0.0.1:5340:8080"
    volumes:
      # Permite atualizacao direta dos arquivos estaticos sem necessidade de rebuild da imagem
      - ./web:/usr/share/nginx/html:ro
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
      - cache_data:/var/cache/nginx
    networks:
      - proxy_default
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

volumes:
  cache_data:

networks:
  proxy_default:
    external: true
```

### 3.3 Arquivo `Dockerfile` (`/opt/quemvotar/Dockerfile`)

```dockerfile
FROM nginx:1.27-alpine-slim

# Criar diretorio de cache dedicado
RUN mkdir -p /var/cache/nginx && chown -R nginx:nginx /var/cache/nginx

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY web/ /usr/share/nginx/html/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
```

### 3.4 Arquivo `nginx.conf` (`/opt/quemvotar/nginx.conf`)

```nginx
# Zona de cache de 50MB para metadados e ate 2GB em disco para respostas JSON do TSE
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=tse_cache:50m max_size=2g inactive=60m use_temp_path=off;

server {
    listen 8080;
    server_name _;

    # Compressao de transferencia veloz para dispositivos moveis
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/javascript application/javascript application/json application/wasm image/svg+xml;

    root /usr/share/nginx/html;
    index index.html;

    # 1. Roteamento do Micro-Proxy de Cache para a API do TSE
    location /quemvotar/api/ {
        # Reescrita de caminho: remove o prefixo /quemvotar/api/ e repassa para o TSE
        rewrite ^/quemvotar/api/(.*)$ /divulga/rest/$1 break;

        proxy_pass https://divulgacandcontas.tse.jus.br;
        proxy_ssl_server_name on;
        proxy_http_version 1.1;

        # Injecao compulsoria de cabecalhos de contexto para superacao do Akamai EdgeSuite
        proxy_set_header Host divulgacandcontas.tse.jus.br;
        proxy_set_header User-Agent "Mozilla/5.0 (Linux; Android 14; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Mobile Safari/537.36";
        proxy_set_header Referer "https://divulgacandcontas.tse.jus.br/";
        proxy_set_header Origin "https://divulgacandcontas.tse.jus.br";
        proxy_set_header Accept "application/json, text/plain, */*";
        proxy_set_header Accept-Language "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7";

        # Liberacao de CORS para navegadores de qualquer cliente
        add_header Access-Control-Allow-Origin "*" always;
        add_header Access-Control-Allow-Methods "GET, OPTIONS" always;
        add_header Access-Control-Allow-Headers "DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range" always;

        # Politica de Cache: 15 minutos para respostas com sucesso (HTTP 200)
        proxy_cache tse_cache;
        proxy_cache_valid 200 15m;
        proxy_cache_valid 404 1m;
        proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
        proxy_cache_lock on;
        add_header X-Cache-Status $upstream_cache_status always;

        # Timeouts estritos para evitar acumulacao de sockets pendentes
        proxy_connect_timeout 8s;
        proxy_send_timeout 15s;
        proxy_read_timeout 15s;
    }

    # 2. Servico de Arquivos Estaticos do Flutter Web (SPA)
    location /quemvotar/ {
        alias /usr/share/nginx/html/;
        try_files $uri $uri/ /quemvotar/index.html;

        # Cache imutavel de longo prazo para binarios versionados (JS, WASM, fontes, imagens)
        location ~* \.(js|css|wasm|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
            expires 1y;
            add_header Cache-Control "public, no-transform, immutable";
        }

        # Desabilitar cache para index.html e manifest.json para garantir atualizacoes instantaneas
        location ~* \.(json|html)$ {
            expires -1;
            add_header Cache-Control "no-store, no-cache, must-revalidate";
        }
    }

    # Redirecionamento de conveniencia
    location = /quemvotar {
        return 301 /quemvotar/;
    }
}
```

---

## 4. Configuracao no Nginx Proxy Manager (NPM)

A configuracao perimetral para `todeolho.org` e efetuada de forma declarativa e segura no painel do NPM ou via arquivo de configuracao em `/opt/proxy/data/nginx/proxy_host/`.

### 4.1 Regras de Proxy Host para `todeolho.org`
* **Domain Names:** `todeolho.org`, `www.todeolho.org`
* **Scheme:** `http`
* **Forward Hostname / IP:** `quemvotar-web` (resolvido automaticamente pelo DNS interno do Docker na rede `proxy_default`)
* **Forward Port:** `8080`
* **SSL:** Habilitado com "Force SSL", "HTTP/2 Support" e "HSTS Enabled", utilizando certificado Let's Encrypt gerado pelo proprio NPM.

### 4.2 Segmentacao de Rotas para Preservacao do Portal Principal
Para assegurar que a rota raiz `/` permaneca livre para o portal institucional futuro, o NPM adota **Custom Locations**:
* **Location `/quemvotar`:**
  * Forward: `http://quemvotar-web:8080/quemvotar`
* **Location `/` (Futuro):**
  * Apontara para o container ou diretorio do portal institucional assim que configurado.

---

## 5. Pipeline de Compilacao e Deploy Continuo

A remessa de atualizacoes do ambiente de desenvolvimento (Windows 11) para a VM Contabo e executada com um unico script de implantacao:

```powershell
# 1. Compilacao do pacote Flutter Web com o base-href ajustado
flutter build web --release --base-href "/quemvotar/"

# 2. Sincronizacao dos arquivos estaticos compilados para a VM via SSH/SCP
scp -r build/web/* root@13.140.190.55:/opt/quemvotar/web/

# 3. Recarregamento gracioso do Nginx no container quemvotar-web (se aplicavel)
ssh -n root@13.140.190.55 "docker exec quemvotar-web nginx -s reload"
```

---

## 6. Procedimentos Operacionais e Diagnostico na VM

Comandos uteis para administracao e verificacao na maquina virtual:

* **Status dos Containers:** `docker ps --filter "name=quemvotar"`
* **Logs em Tempo Real:** `docker logs -f quemvotar-web`
* **Taxa de Acertos de Cache (*Cache Hit Ratio*):**  
  Inspecionar o cabecalho `X-Cache-Status` nas respostas HTTP. Retornos esperados:
  * `HIT`: Resposta entregue instantaneamente a partir do micro-cache em disco (< 2ms).
  * `MISS`: Primeira consulta que requereu acesso aos servidores do TSE.
  * `STALE`: Servidor do TSE temporariamente inacessivel; o Nginx entregou a versao anterior em contingencia sem falhar a interface do eleitor.
