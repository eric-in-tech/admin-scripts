# some problem services get stuck, still running, but won't respond or restart
# kill the process task before trying to give it a normal start

# replace serviceName1 with the process and service names
$serviceName1 = "service1"
$processName1 = "process1"

try {
    Write-Output "Attempting to restart $serviceName1 service."
    # do stuff: kill the process since the service likely won't respond to a stop/restart
    Stop-Process -Name $processName1 -Force
    Start-Sleep -Seconds 5
    Start-Service -Name $serviceName1
    Write-Output "Service $serviceName1 restarted."
    exit 0
} 

catch {
    $ErrorMsg = $_.Exception.Message
    Write-Output "Failed to restart $serviceName1: $ErrorMsg"
    Exit 1
}
