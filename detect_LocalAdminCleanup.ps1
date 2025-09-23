## list all user accounts in local administrators group (excl myIT, -adm, and Administrator)
$List = Get-LocalGroupMember -Group Administrators | Where-Object {
    $_.name -notlike "*myit*" -and 
    $_.name -notlike "*\Administrator" -and 
    $_.name -notlike "*oldIT*" -and
    $_.name -notlike "*-adm" -and
    $_.ObjectClass -eq "User"
}

## list legacy myIT accounts when new LAPS myIT###### is also present
### need to check for count -gt 1 and exit 1 if it is
$myITAccounts = Get-LocalGroupMember -Group Administrators | Where-Object {
    $_.name -like "*myit*" -and
    $_.ObjectClass -eq "User"
}
## still need to do something if we find multiples
Write-Output "Found $($myITAccounts.Count) myIT* accounts in local administrator group."

## how you doin?
Write-Output "Checking for unwanted local admins..."
if ($List.Count -gt 0 -or $myITAccounts.Count -gt 1) {
    Write-Output "Found local admins needing to be cleaned"
    exit 1
} else {
    Write-Output "This house is clean"
    exit 0
}

