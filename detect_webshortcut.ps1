# checks to see if the desktop shortcuts for SystemA and SystemB are pointing to the current prod servers 
# paired as either srv01/srv03 or srv02/srv04
# removes shortcuts if they are the wrong pair compared to current prod


$testpath1 = [Environment]::GetFolderPath("Desktop") + "\SystemA - Prod.url"
$testpath2 = [Environment]::GetFolderPath("Desktop") + "\SystemB - Prod.url"

Try{
    if (!(Test-Path -Path $testpath1 -ErrorAction SilentlyContinue)){
		Write-Host "SystemA shortcut NOT found"
        Exit 1
    }
	
	Write-Host "SystemA shortcut detected OK"
	
	#check for SystemB shortcut, but if SystemA is there, SystemB is probably there too
	if (!(Test-Path -Path $testpath2 -ErrorAction SilentlyContinue)){
		Write-Host "SystemA was found, but SystemB shortcut NOT found"
		Exit 1
	}

	Write-Host "SystemB shortcut detected OK"

	#files found, go check to see if the correct hostname is there
	$testURL1 = Get-Content -path $testpath1
	if (!($testURL1 -like "*srv01*")){
		#SystemA has the wrong URL, delete both shortcuts and let the remediation add them both back fresh
		Write-Host "WRONG hostname found! Removing old shortcuts."
		Remove-Item -Path $testpath1
		Remove-Item -Path $testpath2
		Exit 1
	}
	
	Write-Host "SystemA URL is OK"
	
	#SystemA URL was OK, double-check SystemB
	$testURL2 = Get-Content -Path $testpath2
	if (!($testURL2 -like "*srv03*")){
		#SystemB has the wrong URL, but SystemA was OK? Weird, but let's remove the shortcut and have it added back fresh
		Write-Host "WRONG hostname found! Removing old shortcuts."
		Remove-Item -Path $testpath1
		Remove-Item -Path $testpath2
		Exit 1
	}
	
	Write-Host "SystemB URL is OK"
	
	#I think we passed all of the tests. Huge success!
	Write-Host "Prod shortcuts present and correct!"
	Exit 0
}
Catch {
    $ErrorMsg = $_.Exception.Message
    Write-Host "File detection error: $ErrorMsg"
    Exit 1
}