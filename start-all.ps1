# Script para levantar todos los servicios de NUVO en Windows
# Descripción: Inicia todos los microservicios y el frontend usando PowerShell

$ErrorActionPreference = "Stop"

Write-Host "NUVO - Sistema Bancario" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

$baseDir = (Get-Location).Path

# Función para iniciar un servicio Spring Boot
function Start-MavenService {
    param (
        [string]$ServiceName,
        [int]$Port
    )

    $serviceDir = Join-Path $baseDir $ServiceName
    Write-Host "Iniciando $ServiceName en puerto $Port..." -ForegroundColor Yellow

    # Verificar si el puerto está en uso
    try {
        $conns = Get-NetTCPConnection -LocalPort $Port -ErrorAction Stop
        if ($conns) {
            Write-Host "$ServiceName ya está corriendo en puerto $Port" -ForegroundColor Green
            return
        }
    }
    catch {
        # Puerto no en uso (Excepción esperada)
    }

    if (Test-Path $serviceDir) {
        Push-Location $serviceDir
        $logFileOut = "$env:TEMP\nuvo-$ServiceName.out.log"
        $logFileErr = "$env:TEMP\nuvo-$ServiceName.err.log"
        # Usar mvnw.cmd
        Start-Process -FilePath ".\mvnw.cmd" -ArgumentList "spring-boot:run" -RedirectStandardOutput $logFileOut -RedirectStandardError $logFileErr -WindowStyle Minimized
        Write-Host "$ServiceName iniciado (Logs: $logFileOut, $logFileErr)" -ForegroundColor Green
        Pop-Location
    }
    else {
        Write-Host "Error: No se encuentra el directorio $serviceDir" -ForegroundColor Red
    }
    Write-Host ""
}

# Verificar Docker para PostgreSQL
Write-Host "Verificando PostgreSQL..." -ForegroundColor Yellow
$postgresRunning = $false
try {
    $container = docker ps --format '{{.Names}}' | Where-Object { $_ -eq "nuvo_postgres" }
    if ($container) {
        $postgresRunning = $true
        Write-Host "PostgreSQL (Docker) está corriendo" -ForegroundColor Green
    }
}
catch {
    Write-Host "Error verificando Docker. Asegúrate de que Docker Desktop esté corriendo." -ForegroundColor Red
}

if (-not $postgresRunning) {
    Write-Host "PostgreSQL no está corriendo. Intentando iniciar..." -ForegroundColor Red
    $containerExists = docker ps -a --format '{{.Names}}' | Where-Object { $_ -eq "nuvo_postgres" }
    
    if ($containerExists) {
        docker start nuvo_postgres
    }
    else {
        # Comando docker run simplificado
        $volScripts = "$baseDir\docker\init-scripts:/docker-entrypoint-initdb.d"
        docker run -d --name nuvo_postgres --network host -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=1234 -v $volScripts -v postgres_data:/var/lib/postgresql/data postgres:16-alpine -p 5444:5444
    }
    Write-Host "Esperando DB..."
    Start-Sleep -Seconds 10
}
Write-Host ""

# Iniciar microservicios
Write-Host "Iniciando Microservicios Backend..." -ForegroundColor Yellow
Write-Host ""

Start-MavenService "nuvo-auth-service" 8081
Start-Sleep -Seconds 5

Start-MavenService "nuvo-account-service" 8082
Start-Sleep -Seconds 3

Start-MavenService "nuvo-transaction-service" 8083
Start-Sleep -Seconds 3

Start-MavenService "nuvo-loan-service" 8084
Start-Sleep -Seconds 3

Start-MavenService "nuvo-pool-service" 8085
Start-Sleep -Seconds 3

# Iniciar Frontend
Write-Host "Iniciando Frontend Angular..." -ForegroundColor Yellow
$frontendPort = 4200
$frontendRunning = $false
try {
    $fconns = Get-NetTCPConnection -LocalPort $frontendPort -ErrorAction Stop
    if ($fconns) {
        $frontendRunning = $true
        Write-Host "Frontend ya está corriendo en puerto $frontendPort" -ForegroundColor Green
    }
}
catch {
    # No corriendo
}

if (-not $frontendRunning) {
    $frontendDir = Join-Path $baseDir "nuvo-web-admin"
    if (Test-Path $frontendDir) {
        Push-Location $frontendDir
        $logFileOut = "$env:TEMP\nuvo-frontend.out.log"
        $logFileErr = "$env:TEMP\nuvo-frontend.err.log"
        
        # FIX: Usar npm.cmd para Windows explícitamente y manejo de path
        $npmCmd = "npm.cmd"
        if ((Get-Command "npm.cmd" -ErrorAction SilentlyContinue) -eq $null) {
            $npmCmd = "npm" # Fallback si por alguna razón extraña no es .cmd
        }

        Start-Process -FilePath $npmCmd -ArgumentList "start" -RedirectStandardOutput $logFileOut -RedirectStandardError $logFileErr -WindowStyle Minimized
        Write-Host "Frontend iniciado (Logs: $logFileOut, $logFileErr)" -ForegroundColor Green
        Pop-Location
    }
    else {
        Write-Host "Error: No se encuentra directorio frontend" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "¡Todos los servicios han sido lanzados!" -ForegroundColor Green
Write-Host "Nota: Los servicios pueden tardar unos minutos en arrancar completamente."
