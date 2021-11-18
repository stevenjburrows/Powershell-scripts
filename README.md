# Powershell-scripts
collection of PowerShell scripts that I use 

## removeUser.ps1

### How to run

 run with the upn param 
 ```cmd
 .\removeUser.ps1 -upn <upn or email address>
 ```
 
### Description

This is a basic script to run when someone leaves a company

This will ask prompt you to log in with the Microsoft 365 admin account it will then do the following for the user specifiec in the upn param
1. Convert the mailbox toa shared mailbox
2. Remove all liceneses from the user
3. Block the user from signing in

