# WSLUtils

While trying to make WSL Kali more palatable, these scripts will create or destroy portproxy and host firewall rules to permit reverse shells more easily than configuring bridged networking on the WSL Kali guest.

To execute from an elevated Powershell prompt on the WSL host machine:

`powershell.exe -File "C:\Path\To\Script\Bridge-WslPorts.ps1"`

`powershell.exe -File "C:\Path\To\Script\Unbridge-WslPorts.ps1"`

Idea stolen from https://jwstanly.com/blog/article/Port+Forwarding+WSL+2+to+Your+LAN
