#example shortcut location:
## powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\PCLFontLoad.ps1"

# Set the path to the directory containing the soft font files
$directoryPath = "D:\PCLfonts"

# List of printer IPs
$printerOptions = [ordered]@{
    "1" = @{ IP = "192.168.1.1"; Description = "P01" }
    "2" = @{ IP = "192.168.1.2"; Description = "P02" }
    "3" = @{ IP = "192.168.1.3"; Description = "P03" }
}


# Display printer options with descriptions
Write-Host "Select a printer to send soft fonts to:`n"
foreach ($key in $printerOptions.Keys) {
    $printer = $printerOptions[$key]
    Write-Host "$key. $($printer.IP) - $($printer.Description)"
}

# Prompt user for selection
$selection = Read-Host "`nEnter the number of the printer (1, 2, or 3)"

# Validate selection
if ($printerOptions.Keys -contains $selection) {
    $selectedPrinter = $printerOptions[$selection]
    Write-Host "`nSending fonts to $($selectedPrinter.Description) at $($selectedPrinter.IP)..."

    # Get all files in the directory
    $files = Get-ChildItem -Path $directoryPath -File

    # Loop through each file and send it to the selected printer
    foreach ($file in $files) {
        $filePath = $file.FullName
        Write-Host "  Sending $($file.Name)..."
        lpr -S $selectedPrinter.IP -P raw "$filePath"
    }

    Write-Host "`nAll fonts sent to $($selectedPrinter.Description)."
} else {
    Write-Host "Invalid selection. Please run the script again and choose 1, 2, or 3."
}

Write-Output "`n+-----------+`n[ Complete! ]`n+-----------+`n"
Pause
exit 0
