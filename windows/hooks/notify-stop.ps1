$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

& "$ScriptDir\..\notify.ps1" -Title "Claude Code" -Message "Task complete!" -Sound "None"
