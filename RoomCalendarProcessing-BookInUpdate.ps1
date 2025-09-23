#update BookInPolicy for a room/resource calendar

$room = "RoomMailboxName"
$newUser = "newuser@company.lan"

# Get the current booking policy, then convert each entry from LegacyExchangeDN to SMTP
$currentPolicy = (Get-CalendarProcessing -Identity $room).BookInPolicy

foreach ($dn in $currentPolicy) {
  $recipient = Get-Recipient -identity $dn
  if ($recipient -ne $null) {
   $smtpAddresses += "," + $recipient.primarysmtpaddress
  } else {
   Write-Warning "Could not resolve: $dn"
  }
}
write-output $smtpaddresses

# Add the new user to the array
Set-CalendarProcessing -Identity $room -BookInPolicy ($currentPolicy + $newUser)

