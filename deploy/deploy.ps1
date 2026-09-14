# Script de Build e Deploy Automatizado do Quem Votar para a VM Contabo
param(
    [string]$ServerHost = "13.140.190.55",
    [string]$RemoteDir = "/opt/quemvotar",
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

Write-Host "[DEPLOY] Iniciando processo de deploy para $ServerHost..."

# 1. Compilacao Flutter Web com base-href configurado para subcaminho /quemvotar/
if (-not $SkipBuild) {
    Write-Host "[DEPLOY] Compilando artefatos Flutter Web em modo release (--base-href /quemvotar/)..."
    flutter build web --release --base-href "/quemvotar/"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "[DEPLOY] Falha na compilacao do Flutter Web."
        exit $LASTEXITCODE
    }
} else {
    Write-Host "[DEPLOY] Etapa de build ignorada (-SkipBuild)."
}

# 2. Criacao da estrutura de diretorios remota se nao existir
Write-Host "[DEPLOY] Garantindo diretorios remotos em $RemoteDir..."
ssh root@$ServerHost "mkdir -p $RemoteDir/web"

# 3. Envio dos manifestos de configuracao
Write-Host "[DEPLOY] Sincronizando manifestos de infraestrutura..."
scp deploy/docker-compose.yml root@${ServerHost}:${RemoteDir}/docker-compose.yml
scp deploy/nginx.conf root@${ServerHost}:${RemoteDir}/nginx.conf
scp deploy/Dockerfile root@${ServerHost}:${RemoteDir}/Dockerfile
scp deploy/proxy.mjs root@${ServerHost}:${RemoteDir}/proxy.mjs

# 4. Sincronizacao dos arquivos estaticos compilados
Write-Host "[DEPLOY] Sincronizando estaticos da aplicacao para $RemoteDir/web/..."
scp -r build/web/* root@${ServerHost}:${RemoteDir}/web/

# 5. Ajuste de permissoes, reinicio de servicos e expurgo de cache
Write-Host "[DEPLOY] Ajustando permissoes, aplicando configuracoes e expurgando cache..."
ssh root@$ServerHost "chmod -R 755 $RemoteDir/web && cd $RemoteDir && docker compose up -d --force-recreate && docker exec quemvotar-web rm -rf /var/cache/nginx/* && docker exec quemvotar-web nginx -t && docker exec quemvotar-web nginx -s reload"

Write-Host "[DEPLOY] Deploy concluido com sucesso!"
