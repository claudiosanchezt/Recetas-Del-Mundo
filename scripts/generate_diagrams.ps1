param(
  [string]$OutDir = "docs",
  [string[]]$Svgs = @("docs/endpoints_overview.svg", "docs/architecture_diagram.svg", "docs/auth_flow.svg")
)

Write-Host "Generate diagrams script — output directory: $OutDir"

function Convert-WithInkscape {
  param([string]$inFile, [string]$outFile)
  & inkscape $inFile --export-type=png --export-filename=$outFile
}

function Convert-WithImageMagick {
  param([string]$inFile, [string]$outFile)
  & magick convert $inFile $outFile
}

foreach ($svg in $Svgs) {
  if (-not (Test-Path $svg)) { Write-Host 'Skipping missing: ' + $svg; continue }
  $base = [System.IO.Path]::GetFileNameWithoutExtension($svg)
  $out = Join-Path $OutDir ($base + '.png')
  Write-Host ('Converting ' + $svg + ' -> ' + $out)
  try {
    if (Get-Command inkscape -ErrorAction SilentlyContinue) {
      Convert-WithInkscape -inFile $svg -outFile $out
  Write-Host 'Created: ' + $out + ' (Inkscape)'
      continue
    }
    if (Get-Command magick -ErrorAction SilentlyContinue) {
      Convert-WithImageMagick -inFile $svg -outFile $out
  Write-Host 'Created: ' + $out + ' (ImageMagick)'
      continue
    }
    Write-Error -Message 'Neither Inkscape nor ImageMagick found. Install one to convert SVG -> PNG.'
    break
  } catch {
    $err = $_.Exception.Message
    Write-Error -Message ('Conversion failed for ' + $svg + ': ' + $err)
  }
}

Write-Host 'Done. Review PNGs in' $OutDir 'and commit them if desired.'

