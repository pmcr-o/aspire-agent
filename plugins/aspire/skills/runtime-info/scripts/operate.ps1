[CmdletBinding()]param([string]$Workspace='.',[switch]$Execute)
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';$w=(Resolve-Path -LiteralPath $Workspace).Path
if(-not $Execute){Write-Output ('dry run: aspire --version; inspect AppHost under "'+$w+'"');return}
$a=Get-Command aspire -ErrorAction SilentlyContinue;if(-not $a){throw 'aspire CLI not installed'};$v=(& $a.Source --version|Select-Object -First 1).Trim()
$hosts=@('AppHost.cs','apphost.cs','apphost.mts')|ForEach-Object{Join-Path $w $_}|Where-Object{Test-Path $_ -PathType Leaf}
[ordered]@{version=$v;executable=$a.Source;workspace=$w;appHosts=$hosts}|ConvertTo-Json -Depth 8;return
