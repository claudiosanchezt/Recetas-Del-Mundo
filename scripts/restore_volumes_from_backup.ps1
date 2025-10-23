$ErrorActionPreference = 'Stop'
# Script seguro para restaurar volúmenes desde el tar de backup en Windows PowerShell
Param(
    [string]$BackupTar = (Get-ChildItem .\backups\complete_backup_*.tar.gz | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
)
if (-not $BackupTar) { Write-Error 'No se encontró backup en backups/*.tar.gz'; exit 1 }
$Tmp = Join-Path $env:TEMP ('recetas_restore_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
New-Item -ItemType Directory -Path $Tmp -Force | Out-Null
Write-Host "Extrayendo $BackupTar -> $Tmp"
# usar tar si está disponible (Windows 10/11 trae tar), si no usar 7z/Expand-Archive no maneja .tar.gz directamente
tar -xzf $BackupTar -C $Tmp
$ErrorActionPreference = 'Stop'
# Script seguro para restaurar volúmenes desde el tar de backup en Windows PowerShell
Param(
    [string]$BackupTar = (Get-ChildItem .\backups\complete_backup_*.tar.gz | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
)

if (-not $BackupTar) { Write-Error 'No se encontró backup en backups/*.tar.gz'; exit 1 }

# comprobar si 'tar' está disponible (Windows 10/11 incluye tar; si no, usar WSL/Git-Bash)
if (-not (Get-Command tar -ErrorAction SilentlyContinue)) {
    Write-Error "La utilidad 'tar' no está disponible en este sistema. Ejecuta esto en WSL/Git-Bash o instala tar."; exit 1
}

$Tmp = Join-Path $env:TEMP ('recetas_restore_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
New-Item -ItemType Directory -Path $Tmp -Force | Out-Null
Write-Host "Extrayendo $BackupTar -> $Tmp"
try {
    tar -xzf $BackupTar -C $Tmp
} catch {
    $err = $_.ToString()
    Write-Error ("Fallo al extraer {0}: {1}" -f $BackupTar, $err)
    exit 1
}
$VolumesDir = Join-Path $Tmp 'volumes'
if (-not (Test-Path $VolumesDir)) { Write-Error "No existe la carpeta de volúmenes en el backup: $VolumesDir"; exit 1 }
$files = Get-ChildItem $VolumesDir -Filter '*.tar.gz' -File | Sort-Object Name
if ($files.Count -eq 0) { Write-Host 'No se encontraron archivos de volúmenes para restaurar'; exit 0 }
$i = 0
foreach ($f in $files) {
    $i++
    $base = $f.Name
    $volName = [regex]::Replace($base, '_\d{8}_\d{6}\.tar\.gz$','')
    Write-Host "[$i/$($files.Count)] Restaurando volumen: $volName desde $($f.FullName)"
    # crear volumen si no existe
    $exists = docker volume ls --format '{{.Name}}' | Select-String -Pattern ('^' + [regex]::Escape($volName) + '$') -Quiet
    if (-not $exists) {
        docker volume create $volName | Out-Null
        Write-Host "  Volumen creado: $volName"
        Start-Sleep -Seconds 1
    }
    # preparar mounts (usar --mount evita sintaxis con ':' junto a variable)
    $mountVol = "type=volume,source=$volName,target=/volume"
    $mountBind = "type=bind,source=$($f.FullName),target=/backup/backup.tar.gz,readonly"
    Write-Host "  Ejecutando contenedor temporal para extraer..."
    docker run --rm --mount $mountVol --mount $mountBind alpine sh -c 'set -e; rm -rf /volume/*; tar -xzf /backup/backup.tar.gz -C /volume'
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al extraer $($f.FullName) en volumen $volName (exit $LASTEXITCODE)"; exit 1
    }
    Write-Host "  Restaurado: $volName"
}
Write-Host 'Restauración de volúmenes completada. Temp dir: ' $Tmp
