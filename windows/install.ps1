# Claude Code Notify - Windows Installation Script
# https://github.com/aashutosh-sahni/claude-code-notify

$ErrorActionPreference = "Stop"

$InstallDir = "$env:USERPROFILE\.claude-code-notify"
$RepoUrl = "https://github.com/aashutosh-sahni/claude-code-notify.git"
$IconUrl = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/claude-ai.png"
$IconDir = "$InstallDir\windows\assets"
$IconPath = "$IconDir\claude-logo.png"

Write-Host "Installing Claude Code Notify (Windows)..." -ForegroundColor Cyan

# Install BurntToast if not present
if (-not (Get-Module -ListAvailable -Name BurntToast)) {
    Write-Host "Installing BurntToast module..."
    Install-Module -Name BurntToast -Scope CurrentUser -Force
} else {
    Write-Host "BurntToast module already installed."
}

# Clone or update
if (Test-Path "$InstallDir\.git") {
    Write-Host "Updating existing installation..."
    Push-Location $InstallDir
    git pull --quiet
    Pop-Location
} else {
    if (Test-Path $InstallDir) {
        Write-Host "Removing existing non-git installation..."
        Remove-Item -Recurse -Force $InstallDir
    }
    Write-Host "Cloning repository..."
    git clone --quiet $RepoUrl $InstallDir
}

# Download Claude icon
if (-not (Test-Path $IconDir)) {
    New-Item -ItemType Directory -Path $IconDir -Force | Out-Null
}

Write-Host "Downloading Claude icon..."
try {
    Invoke-WebRequest -Uri $IconUrl -OutFile $IconPath -UseBasicParsing
    Write-Host "Icon saved to $IconPath"
} catch {
    Write-Host "Warning: Could not download icon. Notifications will work without it." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Installed to $InstallDir" -ForegroundColor Green
Write-Host ""
Write-Host "Add this to your ~/.claude/settings.json:" -ForegroundColor Cyan
Write-Host ""

$HooksPath = $InstallDir -replace '\\', '\\'

Write-Host @"
{
  "hooks": {
    "Notification": [
      {
        "matcher": "permission_prompt|elicitation_dialog",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \"$HooksPath\\windows\\hooks\\notify-permission.ps1\""
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell -ExecutionPolicy Bypass -File \"$HooksPath\\windows\\hooks\\notify-stop.ps1\""
          }
        ]
      }
    ]
  }
}
"@

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
