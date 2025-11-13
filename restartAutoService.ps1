# check to see if a service is set to automatic before attempting to restart it
# if the service is set to manual or disabled, ignore it and move on

$serviceName = "DPMService"
try {
    $service = Get-Service -Name $serviceName -ErrorAction Stop # need to rerun this if any properties need to be re-checked
} catch {
        Write-Output "$($serviceName) does not exist!"
        Write-Output "`n+-----------+`n[ FAILED!!! ]`n+-----------+`n"
        exit 1
}

Write-Output "The service $servicename is set to $($service.starttype) and is currently $($service.status)."

# check starttype = Automatic
# if Automatic, check if currently running. If Running then Restart, if Stopped just Start
if ($service.starttype -eq 'Automatic') {
    try {
        if ($service.status -eq 'Running') { #service is already running, just restart
            Write-Output "$serviceName is currently running. Attempting restart."
            Restart-Service -Name $serviceName -ErrorAction Stop
        } else { #service isn't running, fire it up
            Write-Output "$serviceName is stopped. Attempting to start."
            Start-Service -Name $serviceName -ErrorAction Stop
        }
    } catch {
        Write-Output "Failed to start service '$serviceName'. Error: $_"
        Write-Output "`n+-----------+`n[ FAILED!!! ]`n+-----------+`n"
        exit 1
    }
} else {
    Write-Output "$serviceName startup type is set to $($service.starttype). It should not be started at this time."
    Write-Output "`n+-----------+`n[ Complete! ]`n+-----------+`n"
    exit 0
    
}

# get the service properties again
$service = Get-Service -Name $serviceName
Write-Output "The service $serviceName is set to $($service.starttype) and is currently $($service.status)."
Write-Output "`n+-----------+`n[ Complete! ]`n+-----------+`n"
exit 0