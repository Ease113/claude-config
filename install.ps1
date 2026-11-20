# Installs the output styles in this repo into the current user's Claude Code config (Windows).
# Usage (from the repo folder):
#   powershell -ExecutionPolicy Bypass -File install.ps1            # copy styles and enable the default one
#   powershell -ExecutionPolicy Bypass -File install.ps1 -NoEnable  # copy styles only
# The script is kept ASCII-only so Windows PowerShell 5.1 reads it correctly; style names
# are read from each file's front matter as UTF-8.
param(
    [string]$Style = "bianca.md",
    [switch]$NoEnable
)
$ErrorActionPreference = "Stop"

$claudeDir = Join-Path $env:USERPROFILE ".claude"
$destDir = Join-Path $claudeDir "output-styles"
$srcDir = Join-Path $PSScriptRoot "output-styles"
New-Item -ItemType Directory -Force -Path $destDir | Out-Null

Get-ChildItem -Path $srcDir -Filter *.md | ForEach-Object {
    Copy-Item -Force $_.FullName (Join-Path $destDir $_.Name)
    Write-Host "Copied $($_.Name) -> $destDir"
}

if ($NoEnable) { return }

# Read the style's display name from its front matter ("name: ...").
$stylePath = Join-Path $srcDir $Style
$nameLine = Get-Content -Path $stylePath -Encoding UTF8 | Where-Object { $_ -match '^name:\s*(.+)$' } | Select-Object -First 1
if (-not $nameLine) { throw "No 'name:' line found in $stylePath" }
$styleName = ($nameLine -replace '^name:\s*', '').Trim()

# Set "outputStyle" in settings.json, keeping every other setting. Back up the old file first.
$settingsPath = Join-Path $claudeDir "settings.json"
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
if (Test-Path $settingsPath) {
    Copy-Item -Force $settingsPath "$settingsPath.bak"
    $raw = [System.IO.File]::ReadAllText($settingsPath, [System.Text.Encoding]::UTF8)
    $settings = if ($raw.Trim()) { $raw | ConvertFrom-Json } else { New-Object PSObject }
} else {
    $settings = New-Object PSObject
}
$settings | Add-Member -NotePropertyName "outputStyle" -NotePropertyValue $styleName -Force
[System.IO.File]::WriteAllText($settingsPath, ($settings | ConvertTo-Json -Depth 64), $utf8NoBom)
Write-Host "Enabled output style in $settingsPath (backup: settings.json.bak). Restart Claude Code."
