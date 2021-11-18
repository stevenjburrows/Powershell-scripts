#+-------------------------------------------------------------------+  
#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = |  
#|{>/-------------------------------------------------------------\<}|           
#|: | Origianally by  Aman Dhally                                                   
#|: | Updated by Steven Burrows 
#|: | with help from Helge Klein for Delprof2 https://helgeklein.com
#|: | use -profilesold to delete profiles older than the number of days 
#|: | e.g. freeDiskSpace.ps1 -profilesold /d:30 will delete profiles not 
#|: | used for 30 days or older   
#|{>\-------------------------------------------------------------/<}|
#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = |
#+-------------------------------------------------------------------+


#### Variables ####
    param ($profilesold, $listProfile = $true)
	$objShell = New-Object -ComObject Shell.Application
	$objFolder = $objShell.Namespace(0xA)
	$temp = get-ChildItem "env:\TEMP"
	$WinTemp = "c:\Windows\Temp\*"
    $zip = 'C:\temp\Delprof2.zip'
    $file = 'C:\temp\Delprof2 1.6.0\Delprof2.exe'
    $uri = 'https://helgeklein.com/downloads/DelProf2/current/Delprof2%201.6.0.zip'
    
	
#1# Uninstall windows upgrade assistant silently ##
write-host "uninstalls windows upgrade assistant"
	If ((Test-Path "C:\Windows10Upgrade\Windows10UpgraderApp.exe")) { C:\Windows10Upgrade\Windows10UpgraderApp.exe /ForceUninstall | Out-Null }

#2# Delete not in-use *.tmp files
write-Host "Deleteing not in-use *.tmp files"
$FilesToRemove = Get-ChildItem -Path c:\ -Include *.tmp, *.etl -Recurse -ErrorAction SilentlyContinue
$FilesToRemove | Remove-Item -ErrorAction SilentlyContinue




#3# Delete not in-use anything in your %temp% folder

write-host "Delete anything in %temp%"
Remove-Item -Path $env:TEMP\*.* -Recurse

#4# Delete not in-use anything in the C:\Windows\Temp folder

write-host "Delete anything not in-use anything inC:\Windows\Temp"
Remove-Item -Path $env:windir\Temp\*.* -Recurse 


	
#5#	Empty Recycle Bin 
	write-Host "Emptying Recycle Bin." -ForegroundColor Cyan 
	Clear-RecycleBin -Force
	
	
#6# Running Disk Clean up Tool 
	write-Host "Running Windows disk Clean up Tool" -ForegroundColor Cyan
	cleanmgr /verylowdisk | out-Null 

#7# deleteing windows.old
	write-Host "Deleteing Windows.old if disk Clean up Tool missed it" -ForegroundColor Cyan	
	Remove-Item -Path C:\Windows.old -Recurse 

#8# Delete old profiles if if selected
    
if ($profilesold -ne $null) {
    write-Host "delete old profiles" -ForegroundColor Cyan
    
#If the file does not exist, create it.
if (-not(Test-Path -Path $file -PathType Leaf)) {
     try {
        
        Invoke-WebRequest -uri $uri -OutFile $zip
        Expand-Archive $zip -DestinationPath c:\mtech
        Write-Host "The file [$file] has been created. from [$uri] "
         
     }
     catch {
         throw $_.Exception.Message
     }
 }
# If the file already exists, show the message and do nothing.
 else {
     Write-Host "[$file] already exists, deleteing profiles"
 }
 if ($listProfile -eq $true) {
    # currently just lists profiles to see if they will get deleted but doesn't delete them
    Invoke-command -ScriptBlock {& $file '/l' $profilesold}
 } else {
     #delete old profiles
     Write-Host "Deleteing old profiles"
  Invoke-command -ScriptBlock {& $file $profilesold}
 }
}


	write-Host "I finished the cleanup task,Bye Bye " -ForegroundColor Yellow 
##### End of the Script ##### 