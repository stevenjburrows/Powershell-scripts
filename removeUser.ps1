# to run use .\removeUser.ps1 -upn <their upn or email address>
# if no upn is supplied it will ask for one
# by Steven Burrows
# User for when people leave a company
# this will convert their mailbox to a shared mailbox
# remove all their licenses and block their sign in

Connect-ExchangeOnline

#if no upn is supllied it asks for one
if ($upn -eq $null) {
$upn = read-host -Prompt "Please enter a upn or email address" 
}

# Sets mailbos to shared
Set-Mailbox -Identity $upn -Type Shared

#removes all licenses
(get-MsolUser -UserPrincipalName $upn).licenses.AccountSkuId |
foreach{
    Set-MsolUserLicense -UserPrincipalName $upn -RemoveLicenses $_
}

# block user sign in 
Set-MsolUser -UserPrincipalName $upn  -BlockCredential $true

# reminder
Write-host "*******************************"
Write-host "Remember to update SkyKick"
Write-host "*******************************"
