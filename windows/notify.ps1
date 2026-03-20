param(
    [string]$Title = "Claude Code",
    [string]$Message = "Claude needs your attention",
    [string]$Sound = "Default"
)

$IconPath = "$env:USERPROFILE\.claude-code-notify\windows\assets\claude-logo.png"

$params = @{
    Text = $Message
}

if ($Sound -ne "None") {
    $params.Sound = $Sound
}

if (Test-Path $IconPath) {
    $params.AppLogo = $IconPath
}

New-BurntToastNotification @params -Header (New-BTHeader -Id "claude-code" -Title $Title)
