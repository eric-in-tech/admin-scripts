# The way you kill something like that so you can restart it (in this case it restarted it automatically) is to do the following in an elevated powershell.

Get-WmiObject -class win32_service |  ? {$_.state -eq 'stop pending'}

#
# That returns something like this (There may be more than 1 entry if there are multiple stuck processes)
#
#	ExitCode  : 0                                                                  
#	Name      : wuauserv                                                           
#	ProcessId : 11020                                                              
#	StartMode : Manual                                                             
#	State     : Stop Pending                                                       
#	Status    : Degraded  
#
# At that point you run Stop-Process with the Process ID that was returned in the previous query, in this case 11020
#

Stop-Process 11020 -force -PassThru -ErrorAction stop
