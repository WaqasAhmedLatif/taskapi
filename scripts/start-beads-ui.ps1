$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$bdExe = Join-Path $env:APPDATA "npm\node_modules\@beads\bd\bin\bd.exe"

if (-not (Test-Path -LiteralPath $bdExe)) {
    $bdCommand = Get-Command bd -ErrorAction Stop
    $bdExe = $bdCommand.Source
}

$env:BD_BIN = $bdExe

Push-Location $repoRoot
try {
    bdui stop *> $null
    bdui start --host 127.0.0.1 --port 3000
    Write-Output "Beads UI: http://127.0.0.1:3000"
    Write-Output "Workspace: $repoRoot"
    Write-Output "BD_BIN: $env:BD_BIN"
} finally {
    Pop-Location
}
