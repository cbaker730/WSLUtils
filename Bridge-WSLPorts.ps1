$ports = @(80, 443, 4444, 9001);

$wslAddress = bash.exe -c "ifconfig eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"

if ($wslAddress -match '^(\d{1,3}\.){3}\d{1,3}$') {
  Write-Host "[*] WSL IP address: $wslAddress" -ForegroundColor Green
  Write-Host "[*] Ports: $ports" -ForegroundColor Green
}
else {
  Write-Host "[-] Error: Could not find WSL IP address." -ForegroundColor Red
  exit
}

$listenAddress = '0.0.0.0';      # <--- May want to limit this

foreach ($port in $ports) {
  Write-Host -NoNewline "[*] Adding portproxy rule for $listenAddress\:$port" -ForegroundColor Green
  Invoke-Expression "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$listenAddress connectport=$port connectaddress=$wslAddress";
}

$fireWallDisplayName = 'WSLPortForwarding';
$portsStr = $ports -join ",";

Write-Host -NoNewline "[*] Adding host firewall rule to allow outbound and inbound traffic on ports $portsStr" -ForegroundColor Green
Invoke-Expression "New-NetFireWallRule -DisplayName $fireWallDisplayName -Direction Outbound -LocalPort $portsStr -Action Allow -Protocol TCP";
Invoke-Expression "New-NetFireWallRule -DisplayName $fireWallDisplayName -Direction Inbound -LocalPort $portsStr -Action Allow -Protocol TCP";
