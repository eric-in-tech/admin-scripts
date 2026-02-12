# modifies registry key to pre-populate server values for Mitel MiCC and Oaisys clients

Test-path -path "HKCU:\Software\Computer Telephony Solutions\TritonClient"

$regMGMTsplat = @{
    Path = "HKCU:\Software\Computer Telephony Solutions\TritonClient"
    Name = "ServerName"
    Value = "oaisyssrv01"
}
Set-ItemProperty @regMGMTsplat

Test-path -path "HKLM:\SOFTWARE\WOW6432Node\prairieFyre Software Inc\CCM\Common"

$regMiCCsplat = @{
    Path = "HKLM:\SOFTWARE\WOW6432Node\prairieFyre Software Inc\CCM\Common"
    Name = "EnterpriseIPAddress"
    Value = "miccsrv01"
}
Set-ItemProperty @regMiCCsplat
