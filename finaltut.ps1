# To import functions from other files.
Import-Module "C:\...\Functions.ps1"

# Do stuff here.
$host.UI.RawUI.BackgroundColor = "Green"

$psISE # are we running from ISE or command window.

$fourSpaces = " " * 4

Write-Host -NoNewline "Test"
Write-Host -NoNewline " on the same line"

# Args will be an object to start
#[string]$argsAsString = $args[0]


Write-Host "Enter some text:"
$text = Read-Host #use -prompt "Enter some text" for a popup window
"You wrote '$text'"

