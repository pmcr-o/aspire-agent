[CmdletBinding()]param([string]$DashboardUrl='',[string]$ApiKeyEnvVar='',[switch]$Apply)
Set-StrictMode -Version Latest;$ErrorActionPreference='Stop';$a=Get-Command aspire -ErrorAction SilentlyContinue;if(-not $a){throw 'aspire CLI not installed'}
$args=@('agent','mcp','--non-interactive','--nologo');if($DashboardUrl){$u=[uri]$DashboardUrl;if($u.Scheme -notin @('http','https')){throw 'DashboardUrl must be http/https'};$args+=@('--dashboard-url',$DashboardUrl)}
$key='';if($ApiKeyEnvVar){if($ApiKeyEnvVar -notmatch '^[A-Za-z_][A-Za-z0-9_]*$'){throw 'invalid ApiKeyEnvVar'};$key=[Environment]::GetEnvironmentVariable($ApiKeyEnvVar);if([string]::IsNullOrWhiteSpace($key)){throw 'named API key environment variable is empty'};$args+=@('--api-key',$key)}
$shown=($args|ForEach-Object{if($_ -eq $key -and $key){'<redacted>'}else{$_}})-join ' ';if(-not $Apply){Write-Output ('dry run: aspire '+$shown);return}
$p=Start-Process -FilePath $a.Source -ArgumentList $args -PassThru;[ordered]@{status='STARTED';pid=$p.Id;command='aspire '+$shown}|ConvertTo-Json -Compress;return
