param(
  [int]$Count = 20,
  [string]$LogFile = "samples/logs/app.log"
)

$urls = @("/api/orders", "/api/payments", "/health", "/api/users", "/")
$methods = @("GET", "POST", "PUT")
$clients = @("8.8.8.8", "1.1.1.1", "203.0.113.10", "9.9.9.9")

$dir = Split-Path -Parent $LogFile
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

for ($i = 0; $i -lt $Count; $i++) {
    $url = $urls[(Get-Random -Minimum 0 -Maximum $urls.Count)]
    $method = $methods[(Get-Random -Minimum 0 -Maximum $methods.Count)]
    $client = $clients[(Get-Random -Minimum 0 -Maximum $clients.Count)]
    $status = if ((Get-Random -Minimum 0 -Maximum 10) -lt 2) { 500 + (Get-Random -Minimum 0 -Maximum 50) } else { 200 + (Get-Random -Minimum 0 -Maximum 100) }
    $ts = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $line = '{"@timestamp":"' + $ts + '","message":"' + $method + ' ' + $url + '","status":' + $status + ',"client_ip":"' + $client + '","service":"web"}'
    Add-Content -Path $LogFile -Value $line
}

Write-Host "Generated $Count log lines into $LogFile"
