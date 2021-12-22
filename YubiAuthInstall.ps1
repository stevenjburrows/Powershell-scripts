# Downloads and installs the latest version of the Yubico Authentication app for windows silently
# to use type
# .\YubiAuthInstall.ps1 -path C:\destination\
# alway have a trainling \ on the file path
# Written by Steven Burrows

#params
param($path)



if ($path -eq $null) {
$path = C:\temp\ 
}


$msi =  $path + 'yubiauth.msi'
$uri = 'https://developers.yubico.com/yubioath-desktop/Releases/yubioath-desktop-latest-win64.msi'
#If the file does not exist, create it.
if (-not(Test-Path -Path $msi -PathType Leaf)) {
     try {
        
        Invoke-WebRequest -uri $uri -OutFile $msi
        Write-Host "The file [$msi] has been created. from [$uri] "
         
     }
     catch {
         throw $_.Exception.Message
     }
 }
# If the file already exists, show the message and do nothing.
 else {
     Write-Host "[$msi] already exists"
 }

 # Installs yubikey authenticator app 64bit
 Invoke-command -ScriptBlock {& $msi '/quiet'}

 Write-Host "installed"
