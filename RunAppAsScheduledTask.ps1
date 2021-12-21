#
# needs to be run with admin rights in order to add the scheduled task
# all params are required and it will ask if they are not filled entered
# Written By Steven Burrows
#

#params
param($app, $appName, $shortcutPath)

if ($app -eq $null) {
$app = read-host -Prompt "Please enter a valid path to application" 
}

if ($appName -eq $null) {
$appName = read-host -Prompt "Please enter a name for the application" 
}

if ($shortcutPath -eq $null) {
$shortcutPath = read-host -Prompt "Please enter a valid path to save the shortcut to" 
}

$action = New-ScheduledTaskAction -Execute $app
$TaskName = $appName
Register-ScheduledTask -Action $action -TaskName $TaskName  -RunLevel Highest

$TargetFile = "C:\Windows\System32\schtasks.exe"
#$ShortcutFile = "$env:Public\Desktop\" + $TaskName + " Admin.lnk"
$ShortcutFile = $shortcutPath + $TaskName + " Admin.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Arguments = '/run' + ' /tn ' + $TaskName
$Shortcut.Save()