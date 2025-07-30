Get-CimInstance Win32_PhysicalMemory | Select-Object `
    DeviceLocator, Manufacturer, @{Name="Capacity(GB)";Expression={[math]::Round($_.Capacity / 1GB, 2)}}, `
    Name, PartNumber, Model, Tag, ConfiguredClockSpeed | ft
