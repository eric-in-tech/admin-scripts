# update newPath and displayName with application that needs to be allowed
$newPath = "C:\Program Files\someApp.exe"
$displayName = "App Name 1"

# Add Allow rules for the new 64-bit path
New-NetFirewallRule -DisplayName $displayName -Direction Inbound -Program $newPath -Action Allow -Profile Domain,Private,Public -Protocol TCP
New-NetFirewallRule -DisplayName $displayName -Direction Inbound -Program $newPath -Action Allow -Profile Domain,Private,Public -Protocol UDP

Write-Output "$displayName firewall rules updated for new client application."
exit 0
