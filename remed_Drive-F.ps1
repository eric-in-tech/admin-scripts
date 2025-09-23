$DriveLetter = "F"
$Path = "\\dc2xfile01.fcs.lan\Dept"
$Label = "Dept on DC2xFile01"

Write-Output "Mapping network drive $($DriveLetter): $($Path)"
$null = New-PSDrive -PSProvider FileSystem -Name $DriveLetter -Root $Path -Description $Label -Persist -Scope global -EA Stop
(New-Object -ComObject Shell.Application).NameSpace("$($DriveLetter):").Self.Name = $Label
Get-PSDrive -name $DriveLetter