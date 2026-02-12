#create the shortcut on All Users Desktop (Public\Desktop)
# update URL along with the detection script when prod server pairs are swapped
# srv01/srv03 OR srv02/srv04

$deskfolderpath = [Environment]::GetFolderPath("Desktop")
$shortcut1 = $deskfolderpath + "\SystemA - Prod.url"
$shortcut2 = $deskfolderpath + "\SystemB - Prod.url"

$Shell = New-Object -ComObject ("WScript.Shell")
$Favorite1 = $Shell.CreateShortcut($shortcut1)
$Favorite1.TargetPath = "http://srv01"
$Favorite1.Save()
$Favorite2 = $Shell.CreateShortcut($shortcut2)
$Favorite2.TargetPath = "http://srv03"
$Favorite2.Save()
