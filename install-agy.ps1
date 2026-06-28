# Slopnought — Antigravity (agy) installer for PowerShell

$ErrorActionPreference = "Stop"

$PluginRoot = $PSScriptRoot
if (-not $PluginRoot) {
    $PluginRoot = Get-Location
}

$SkillFile = Join-Path $PluginRoot "skills\slopnought\SKILL.md"
$ToolMapFile = Join-Path $PluginRoot "skills\slopnought\references\antigravity-tools.md"
$ManifestFile = Join-Path $PluginRoot "antigravity-plugin\plugin.json"

if (-not (Test-Path $SkillFile)) {
    Write-Error "Error: SKILL.md not found at $SkillFile"
}

if (-not (Test-Path $ManifestFile)) {
    Write-Error "Error: plugin.json not found at $ManifestFile"
}

# Create staging directory
$StagingDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName())
$null = New-Item -ItemType Directory -Path $StagingDir

try {
    Write-Host "Building Antigravity plugin in staging directory..."
    
    # Copy skills directory
    Copy-Item -Path (Join-Path $PluginRoot "skills") -Destination $StagingDir -Recurse -Force
    
    # Read skill content and strip YAML frontmatter
    $SkillContent = Get-Content -Raw -Path $SkillFile
    $SkillBody = $SkillContent -replace "^(?s)---\r?\n.*?\r?\n---\r?\n", ""
    
    # Read tool mapping
    $ToolMap = ""
    if (Test-Path $ToolMapFile) {
        $ToolMap = Get-Content -Raw -Path $ToolMapFile
    }
    
    # Generate ANTIGRAVITY.md
    $Bootstrap = @"
<EXTREMELY_IMPORTANT>
You have Slopnought installed.

**IMPORTANT: The slopnought skill content is included below.
It is ALREADY LOADED - you are currently following it.
Do NOT use the skill tool to load "slopnought" again - that would be redundant.**

$SkillBody

$ToolMap
</EXTREMELY_IMPORTANT>
"@
    
    $BootstrapFile = Join-Path $StagingDir "ANTIGRAVITY.md"
    Set-Content -Path $BootstrapFile -Value $Bootstrap -Encoding utf8
    
    # Copy manifest
    Copy-Item -Path $ManifestFile -Destination (Join-Path $StagingDir "plugin.json") -Force
    
    Write-Host "Staging directory ready at: $StagingDir"
    
    # Check if agy is available
    $AgyPath = Get-Command agy -ErrorAction SilentlyContinue
    if ($AgyPath) {
        Write-Host "Running: agy plugin install $StagingDir"
        & agy plugin install $StagingDir
        Write-Host "Slopnought installed successfully for Antigravity!"
    } else {
        $CustomAgyPath = "$env:USERPROFILE\AppData\Local\agy\bin\agy.exe"
        if (Test-Path $CustomAgyPath) {
            Write-Host "Running: $CustomAgyPath plugin install $StagingDir"
            & $CustomAgyPath plugin install $StagingDir
            Write-Host "Slopnought installed successfully for Antigravity!"
        } else {
            Write-Warning "Warning: 'agy' not found in PATH."
            Write-Host "To install manually, run:"
            Write-Host "  agy plugin install $StagingDir"
            Write-Host "Or copy the staging directory contents to your Antigravity plugins directory."
        }
    }
} finally {
    Remove-Item -Path $StagingDir -Recurse -Force -ErrorAction SilentlyContinue
}
