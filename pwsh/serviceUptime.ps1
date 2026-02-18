# modify these as needed:
$serviceName = "A1Agent"
$processName = "action1_agent" # used for killing the process that may be hung up
$maxDays = 30

#
$Service = Get-CimInstance -ClassName Win32_Service -Filter "Name = '$($serviceName)'"
$Process = Get-CimInstance -ClassName Win32_Process -Filter "ProcessId = $($Service.ProcessId)"
$svcUptime = (Get-Date) - $Process.CreationDate
$days = $svcUptime.TotalDays
Write-Output "$serviceName service has been up for $days days."

if ($days -gt $maxDays) {
    Write-Warning "$serviceName has been up for over $maxDays days!"
    # do some stuff or exit as an err?
    #exit 1
    # kill the process since the service likely won't respond to a stop/restart
    Stop-Process -Name "$($processName)" -Force
    Start-Sleep -Seconds 5
    Start-Service -Name "$($serviceName)"
    Write-Warning "$serviceName has been restarted."
    exit 1
}

Write-Output "No further action taken."
exit 0
