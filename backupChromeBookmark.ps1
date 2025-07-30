<#
    Export or Import Google Chrome bookmarks
    Run as currently logged in user
    Parameter 1 or 2 to export or import to the user's desktop folder. File is named "<username> - Chrome Bookmarks Backup.json"
    
#>
param (
    # 1 = Export, 2 = Import
    [Parameter(Mandatory=$true)]
    [string]$action
)

#-------------------------------
## Find the user-specific paths
#-------------------------------

# Get the username of the currently logged-in user
$userName = $env:USERNAME
Write-Output "$username is currently logged in"

# Get the SID of the user
$sid = (New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier]).Value
#Write-Output "$username security identifier is $sid"

# Get the profile path using the SID
$profilePath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid").ProfileImagePath
Write-Output "$username profile is located at $profilePath"

# Registry hive mount as drive
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS

# Check the registry for the Desktop path
$desktopPath = (Get-ItemProperty -Path "HKU:\$sid\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders").Desktop
Write-Output "$username Desktop folder is located at $desktopPath"

# Cleanup registry mount
Remove-PSDrive -Name HKU

# Define the path to Chrome's default bookmarks file
$chromeProfilePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"
$bookmarksFile = Join-Path -Path $chromeProfilePath -ChildPath "Bookmarks"

# Define the default backup file path in the user's Desktop folder
$defaultBackupDestination = Join-Path -Path $desktopPath -ChildPath "$userName - Chrome Bookmarks Backup.json"

#--------------------
## Backup or Restore
#--------------------

if ($action -eq "1") {
    # Backup bookmarks
    if (Test-Path $bookmarksFile) {
        # Copy the bookmarks file to the default backup destination
        Copy-Item -Path $bookmarksFile -Destination $defaultBackupDestination -Force
        Write-Host "Chrome bookmarks have been successfully backed up to $defaultBackupDestination"
    } else {
        Write-Host "Chrome bookmarks file not found. Please ensure Chrome is installed and has a profile with bookmarks."
    }
}
elseif ($action -eq "2") {
    # Restore bookmarks
    if (Test-Path $defaultBackupDestination) {
        Copy-Item -Path $defaultBackupDestination -Destination $bookmarksFile -Force
        Write-Host "Chrome bookmarks have been successfully restored from the backup."
    } else {
        Write-Host "Copy failed."
    }
}
else {
    Write-Host "Invalid selection. Please enter 1 to Backup or 2 to Restore."
}