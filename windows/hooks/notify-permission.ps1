$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

& "$ScriptDir\..\notify.ps1" -Title "Claude Code" -Message "Claude needs your attention" -Sound "IM"
