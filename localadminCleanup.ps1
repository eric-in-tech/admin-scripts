##
## remove AAD user accounts from the local PCs Administrator group, except for the builtin Administrator and the LAPS-managed myIT* accounts.
##
$List = Get-LocalGroupMember -Group Administrators | Where-Object {
    $_.name -notlike "*myit*" -and 
    $_.name -notlike "*\Administrator" -and 
	$_.name -notlike "*oldIT*" -and
	$_.name -notlike "*-adm" -and
    $_.ObjectClass -eq "User"
}

foreach ($User in $List) {
    Write-Output "Removing $($User.Name)"
    Remove-LocalGroupMember -Group Administrators -Member $User.Name -ErrorAction Continue
}

##
## list legacy myIT accounts when new LAPS myIT###### is also present
##
$myITAccounts = Get-LocalGroupMember -Group Administrators | Where-Object {
    $_.name -like "*myit*" -and
    $_.ObjectClass -eq "User"
}
Write-Output "Found $($myITAccounts.Count) myIT* accounts in local administrator group."
##
## if more than 1 myIT* account found, clean up legacy myIT and leave the new LAPS managed account as-is
##
if ($myITAccounts.Count -gt 1) {
	Write-Output "Legacy myIT* account found. Cleaning..."
	## check if legacy myIT is the built-in Administrator account renamed
	$legacyMYIT = Get-LocalUser -Name "myIT"
	if ($legacyMYIT.SID.Value -match '-500$') {
		Write-Output "The legacy myIT account is a renamed built-in Administrator account. Unable to remove from Administrators group or delete"
		Disable-LocalUser $legacyMYIT.Name
		Rename-LocalUser -Name $legacyMYIT.Name -NewName "oldIT"
		Write-Output "The legacy myIT account has been disabled and renamed."
	} else {
		Write-Output "The legacy myIT account can be removed."
		Remove-LocalGroupMember -Group Administrators -Member $legacymyIT.Name -ErrorAction Continue
		Disable-LocalUser $legacyMYIT.Name
		Remove-LocalUser $legacyMYIT.Name
		Write-Output "Legacy myIT cleaned up!"
	}	
}

##
## disable built-in Administrator account just in case it's separate from the old myIT
##
Write-Output "`nDisabling builtin local administrator"
$builtinAdmin = Get-LocalUser | Where-Object { $_.SID.Value -match '-500$' }
Disable-LocalUser $builtinAdmin.Name -ErrorAction Continue

##
Write-Output "Displaying remaining local user accounts:`n"
Get-LocalUser | Select-Object Name, Enabled, Description | Format-Table -AutoSize


Write-Output "`n+-----------+`n[ Complete! ]`n+-----------+`n"
exit 0