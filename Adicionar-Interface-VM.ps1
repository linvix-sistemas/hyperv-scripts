# Nome da interface Interna da VM.
$VMIntName = "VMinterno";
$VMIntIP = "172.16.97.1";

# Cria o Adaptador Interno
New-VMSwitch -Name $VMIntName -SwitchType Internal

# Configura o IP Fixo no Adaptador - Remove
$AdapterVM = (Get-NetAdapter).Where({ $_.Name -Match $VMIntName })

# Remove ip anterior, caso tenha de uma tentativa
If (($AdapterVM | Get-NetIPConfiguration).IPv4Address.IPAddress) {
    $AdapterVM | Remove-NetIPAddress -AddressFamily "IPv4" -Confirm:$false
}
If (($AdapterVM | Get-NetIPConfiguration).Ipv4DefaultGateway) {
    $AdapterVM | Remove-NetRoute -AddressFamily "IPv4" -Confirm:$false
}

# Configura o IP Fixo no Adaptador - Adiciona
$AdapterVM | New-NetIPAddress -IPAddress $VMIntIP -PrefixLength 24