##
## remove AAD user accounts from the local PCs Administrator group, except for the builtin Administrator and the LAPS-managed myIT* accounts.
##
$List = Get-LocalGroupMember -Group Administrators | Where-Object {
    $_.name -notlike "*yourit*" -and 
    $_.name -notlike "*\Administrator" -and 
    $_.ObjectClass -eq "User"
}

foreach ($User in $List) {
    Write-Output "Removing $($User.Name)"
    Remove-LocalGroupMember -Group Administrators -Member $User.Name -ErrorAction Continue
}

##
## list legacy yourIT accounts when new LAPS yourIT###### is also present
##
$yourITAccounts = Get-LocalGroupMember -Group Administrators | Where-Object {
    $_.name -like "*yourit*" -and
    $_.ObjectClass -eq "User"
}
Write-Output "Found $($yourITAccounts.Count) yourIT* accounts in local administrator group."
##
## if more than 1 yourIT* account found, clean up legacy yourIT and leave the new LAPS managed account as-is
##
if ($yourITAccounts.Count -gt 1) {
	Write-Output "Legacy yourIT* account found. Cleaning..."
	## check if legacy yourIT is the built-in Administrator account renamed
	$legacyyourIT = Get-LocalUser -Name "yourIT"
	if ($legacyyourIT.SID.Value -match '-500$') {
		Write-Output "The legacy yourIT account is a renamed built-in Administrator account. Unable to remove from Administrators group or delete"
		Disable-LocalUser $legacyyourIT.Name
		Write-Output "The legacy yourIT account has been disabled."
	} else {
		Write-Output "The legacy yourIT account can be removed."
		Remove-LocalGroupMember -Group Administrators -Member $legacyyourIT.Name -ErrorAction Continue
		Disable-LocalUser $legacyyourIT.Name
		Remove-LocalUser $legacyyourIT.Name
		Write-Output "Legacy yourIT cleaned up!"
	}	
}

##
## disable built-in Administrator account just in case it's separate from the old yourIT
##
Write-Output "`nDisabling builtin local administrator"
$builtinAdmin = Get-LocalUser | Where-Object { $_.SID.Value -match '-500$' }
Disable-LocalUser $builtinAdmin.Name -ErrorAction Continue

##
Write-Output "Displaying remaining local user accounts:`n"
Get-LocalUser | Select-Object Name, Enabled, Description | Format-Table -AutoSize


Write-Output "`n+-----------+`n[ Complete! ]`n+-----------+`n"

exit 0

