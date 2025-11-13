# original from NinjaOne script share forum
# produces a basic listing of important physical details on a PC's RAM components

function Translate-FormFactor {
    param(
        [int]$FormFactor
    )
    switch ($FormFactor) {
        8 { return "DIMM" }
        12 { return "SODIMM" }
        default { return "Unknown" }
    }
}

function Translate-DDRType {
    param(
        [int]$SMBIOSMemoryType
    )
    switch ($SMBIOSMemoryType) {
        20 { return "DDR3" }
        21 { return "DDR3" }
        24 { return "DDR4" }
        25 { return "DDR4" }
        26 { return "DDR4" }
        30 { return "DDR5" }
        34 { return "DDR5" }
        default { return "Unknown" }
    }
}

$installeddimms = ((Get-CimInstance -Class "CIM_PhysicalMemory") | Measure-Object).Count
$availabledimms = Get-CimInstance -Class "Win32_PhysicalMemoryArray" | Select-Object -ExpandProperty MemoryDevices
Write-Output "Installed: $installeddimms / Max: $availabledimms"

$Speed = Get-WmiObject Win32_PhysicalMemory | Select-Object -ExpandProperty Speed | Get-Unique
$FormFactor = Get-WmiObject Win32_PhysicalMemory | Select-Object -ExpandProperty FormFactor | ForEach-Object { Translate-FormFactor -FormFactor $_ } | Get-Unique
$Manufacturer = Get-WmiObject Win32_PhysicalMemory | Select-Object -ExpandProperty Manufacturer | Get-Unique
$Capacity = Get-WmiObject Win32_PhysicalMemory | Select-Object -ExpandProperty Capacity
$DDRType = Get-WmiObject Win32_PhysicalMemory | Select-Object -ExpandProperty SMBIOSMemoryType | ForEach-Object { Translate-DDRType -SMBIOSMemoryType $_ } | Get-Unique

$TotalCapacity = ($Capacity | Measure-Object -Sum).Sum

$RAMDetails = @"
Speed: $Speed
Form Factor: $FormFactor
DDR Type: $DDRType
Manufacturer: $Manufacturer
Slot Capacity: $($Capacity -join " / ")
"@


Write-Output $RAMDetails
