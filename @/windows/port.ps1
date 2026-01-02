$ip = "192.168.22.115"
$ip = $(wsl hostname -I)
$ip = $ip.Trim()

Write-Output "WSL IP: $ip"

function ForwardPort($port) {
    netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 connectaddress=$ip listenport=$port connectport=$port
}

ForwardPort 22
ForwardPort 65432
ForwardPort 8888
ForwardPort 3000

wsl sudo /etc/init.d/ssh restart
