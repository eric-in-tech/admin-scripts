# try to start up the services if they're not running

# replace serviceNameX with whatever service name(s) need to be addressed
$Services = "serviceName1", "serviceName2", "serviceName3"

# drop a log
$LogPath = "C:\ProgramData\ITdata\service-start_$(Get-Date -Format 'yyyyMMdd').log"

# clean up old logs
Get-ChildItem "C:\Logs\service-start_*.log" -ErrorAction SilentlyContinue |
    Where-Object LastWriteTime -lt (Get-Date).AddDays(-30) |
    Remove-Item -Force

Start-Transcript -Path $LogPath -Append

# loop through the service list and try to start each one
foreach ($Svc in $Services) {
    try {
        Start-Service -Name $Svc -PassThru -ErrorAction Stop | Select-Object Name, Status
    }
    catch {
        Write-Warning "Failed to start '$Svc': $_"
    }
}

Stop-Transcript
