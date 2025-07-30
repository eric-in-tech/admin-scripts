# Prompt for the path to the directory
$Path = Read-Host "Enter the directory path"

# Prompt for the number of days
#$Days = Read-Host "Enter the number of days"
$Days = 2555 # 7 years if not prompting

# Calculate the date threshold
$DateThreshold = (Get-Date).AddDays(-[int]$Days)

# Get all files older than the specified number of days
$Files = Get-ChildItem -Path $Path -File -Recurse | Where-Object { $_.LastWriteTime -lt $DateThreshold }

# Display the files in a table format
$Files | Select-Object Name, @{Name="Path";Expression={$_.DirectoryName}}, @{Name="Size (KB)";Expression={[math]::round($_.Length / 1KB, 2)}}, LastWriteTime | Format-Table -AutoSize

# Prompt for confirmation before deleting files
$Confirm = Read-Host "Do you want to delete these files? (Y/N)"

if ($Confirm -eq "Y") {
    # Delete the files
    $Files | Remove-Item -Force -WhatIf
    Write-Host "Files would be deleted. Remove -WhatIf to actually delete the files."
} else {
    Write-Host "Operation cancelled. No files were deleted."
}