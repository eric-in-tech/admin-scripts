# search the last X days
$Days = 7
$DateThreshold = (Get-Date).AddDays(-[int]$Days)

# get all the files in this directory that are 0KB modified in the last X days and export list to a CSV file
$DirPath = "E:\Reports"
$ExportPath = "E:\Reports\zeroKfiles.csv"
Get-ChildItem -path $DirPath -File -Recurse | Where-Object {$_.Length -eq 0 -and $_.LastWriteTime -gt $Datethreshold } | Export-Csv -Path $ExportPath -NoTypeInformation