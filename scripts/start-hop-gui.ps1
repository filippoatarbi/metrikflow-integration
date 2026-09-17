$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$hopHome = "C:\Tools\apache-hop-client-2.18.1\hop"
$javaHome = "C:\Program Files\Microsoft\jdk-21.0.11.10-hotspot"

$javaExe = Join-Path $javaHome "bin\java.exe"
$hopGui = Join-Path $hopHome "hop-gui.bat"

if (-not (Test-Path $javaExe)) {
    throw "Java 21 non trovato: $javaExe"
}

if (-not (Test-Path $hopGui)) {
    throw "Apache Hop GUI non trovato: $hopGui"
}

# Java 21 solo per Apache Hop.
# Il Java globale di Windows non viene modificato.
$env:JAVA_HOME = $javaHome
$env:Path = "$(Join-Path $javaHome 'bin');$env:Path"

# Configurazione Hop specifica del progetto MetrikFlow
$env:HOP_CONFIG_FOLDER = Join-Path $projectRoot "config\gui"

Set-Location $projectRoot

Write-Host ""
Write-Host "=== MetrikFlow - Apache Hop GUI ==="
Write-Host "Project: $projectRoot"
Write-Host "JAVA_HOME: $env:JAVA_HOME"
Write-Host "HOP_CONFIG_FOLDER: $env:HOP_CONFIG_FOLDER"
Write-Host ""

& $javaExe -version

Write-Host ""
Write-Host "Avvio Apache Hop..."
Write-Host ""

& $hopGui
