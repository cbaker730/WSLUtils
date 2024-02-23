$ports = @(80, 443, 4444, 9001);

$wslAddress = bash.exe -c "ifconfig eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"

if ($wslAddress -match '^(\d{1,3}\.){3}\d{1,3}$') {
  Write-Host "WSL IP address: $wslAddress" -ForegroundColor Green
  Write-Host "Ports: $ports" -ForegroundColor Green
}
else {
  Write-Host "Error: Could not find WSL IP address." -ForegroundColor Red
  exit
}

$listenAddress = '0.0.0.0';      # <--- If you limited this address when the bridge was created, change it here too

foreach ($port in $ports) {
  Write-Host -NoNewline "[*] Removing portproxy rule for $listenAddress\:$port" -ForegroundColor Green
  Invoke-Expression "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$listenAddress";
}

$fireWallDisplayName = 'WSLPortForwarding';
$portsStr = $ports -join ",";

Write-Host -NoNewline "[*] Removing host firewall rule $fireWallDisplayName to disallow outbound and inbound traffic on ports $portsStr" -ForegroundColor Green
Invoke-Expression "Remove-NetFireWallRule -DisplayName $fireWallDisplayName";

Invoke-Expression "netsh interface portproxy show v4tov4";
