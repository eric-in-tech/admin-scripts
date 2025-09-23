## used as an Intune remediation script to map a specific UNC path to a specific drive letter and display a friendly label in Explorer 

$DriveLetter = "A"
$Path = "\\servername01.lan\Dept"
$Label = "Dept on ServerName01"

Write-Output "Mapping network drive $($DriveLetter): $($Path)"
$null = New-PSDrive -PSProvider FileSystem -Name $DriveLetter -Root $Path -Description $Label -Persist -Scope global -EA Stop
(New-Object -ComObject Shell.Application).NameSpace("$($DriveLetter):").Self.Name = $Label

Get-PSDrive -name $DriveLetter
