<#
    Export or Import Windows wifi profiles
    Run as system/admin user
    Parameter 1 or 2 to export or import to the user's desktop folder.
    
#>
param (
    # 1 = Export, 2 = Import
    [Parameter(Mandatory=$true)]
    [string]$action
)

## Find the user-specific paths
##-----------------------------
# Get the username of the currently logged-in user
$username = (Get-WmiObject -Class Win32_ComputerSystem).UserName
Write-Output "$username is currently logged in"

# Get the SID of the user
$sid = (New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier]).Value
#Write-Output "$username security identifier is $sid"

# Get the profile path using the SID
$profilePath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid").ProfileImagePath
Write-Output "$username profile is located at $profilePath"

New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS

# Check the registry for the Desktop path
$desktopPath = (Get-ItemProperty -Path "HKU:\$sid\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders").Desktop
$desktopPath = $desktopPath -replace '%USERPROFILE%', $profilePath
Write-Output "$username Desktop folder is located at $desktopPath"

Remove-PSDrive -Name HKU

# Define the folder to store the Wi-Fi profiles
$wifiFolder = Join-Path -Path $desktopPath -ChildPath "WiFiProfiles"

if ($action -eq "1") {
    # Backup
    # Create the folder if it doesn't exist
    if (-Not (Test-Path -Path $wifiFolder)) {
        New-Item -ItemType Directory -Path $wifiFolder
    }

    ##Export all Wi-Fi profiles
    ##-------------------------
    netsh wlan export profile key=clear folder="$wifiFolder"
    Write-Output "All Wi-Fi profiles have been exported to $wifiFolder."
} elseif ($action -eq "2") {
    ##Import wifi profiles
    ##--------------------
    $profiles = Get-ChildItem -Path $wifiFolder -Filter *.xml

    foreach ($profile in $profiles) {
        netsh wlan add profile filename="$($profile.FullName)" user=all
	    Write-Output "Adding $profile..."
    }
    Write-Output "All Wi-Fi profiles have been imported from $wifiFolder."
} else {
    Write-Host "Invalid selection. Please enter 1 to Backup or 2 to Restore."
}
