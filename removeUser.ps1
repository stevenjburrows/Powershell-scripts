# to run use .\removeUser.ps1 -upn <their upn or email address>
# if no upn is supplied it will ask for one
# use -login for login propmts without it it assumes your shell is already logged in
# -message allows you to add an auto reply
# by Steven Burrows
# User for when people leave a company
# this will convert their mailbox to a shared mailbox
# remove all their licenses and block their sign in
# use -message to add an auto reply to the shared mailbox as well

#params
param(
    $upn, 
    [switch]$login, 
    $message,
    [switch]$install
    )

if($install){
    Get-InstalledModule Microsoft.Graph
    Write-host "Installed Microsoft.Graph" -BackgroundColor Green -ForegroundColor White

    Install-Module MSOnline
    Write-host "Installed MSOnline" -BackgroundColor Green -ForegroundColor White

    Install-Module ExchangeOnline
    Write-host "Installed ExchangeOnline" -BackgroundColor Green -ForegroundColor White
}
#if no upn is supllied it asks for one
if ($null -eq $upn) {
$upn = read-host -Prompt "Please enter a upn or email address" 
}

if($login -eq $true) {
Connect-MsolService
Connect-ExchangeOnline
}

# Sets mailbos to shared
Set-Mailbox -Identity $upn -Type Shared
Write-host "converted to a shared mailbox" -BackgroundColor Red -ForegroundColor White

#removes all licenses
(get-MsolUser -UserPrincipalName $upn).licenses.AccountSkuId |
ForEach-Object{
    Set-MsolUserLicense -UserPrincipalName $upn -RemoveLicenses $_
}

Write-host "licenses removed" -BackgroundColor Red -ForegroundColor White
# block user sign in 
Set-MsolUser -UserPrincipalName $upn  -BlockCredential $true

Write-host "sign in blocked" -BackgroundColor Red -ForegroundColor White

if($null -ne $message){
Set-MailboxAutoReplyConfiguration -Identity $upn -AutoReplyState Enabled -InternalMessage $message
Write-host "Auto reply added" -BackgroundColor Red -ForegroundColor White
}


# reminder
Write-host "*******************************"
Write-host "Remember to update SkyKick"
Write-host "*******************************"
