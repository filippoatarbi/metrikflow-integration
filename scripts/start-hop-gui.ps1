$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$hopHome = "C:\Tools\apache-hop-client-2.18.1\hop"

$env:HOP_CONFIG_FOLDER = Join-Path $projectRoot "config\gui"

Set-Location $projectRoot

& (Join-Path $hopHome "hop-gui.bat")