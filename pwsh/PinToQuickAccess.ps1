# Pins a folder to File Explorer's Quick Access list
# run in user context
$path = "C:\Path\ToFolder\"
$qa = New-Object -com shell.application
$qa.NameSpace($path).Self.InvokeVerb("pintohome")
