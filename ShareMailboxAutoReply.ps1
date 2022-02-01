# set a default auto reply to all shared mailboxes with a particular domain
# use the param domain to incluse *@domain.com
# Developed by Steven Burrows

params($domain, $message)

#if no domain is supllied it asks for one
if ($domain -eq $null) {
    $domain = read-host -Prompt "Please enter a domain name and incluse a *@ before it e.g. *@domain.com" 
}

if ($message -eq $null) {
    $message = read-host -Prompt "Please enter a reply message that you would like included" 
}

Connect-ExchangeOnline
$mailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize unlimited | Where-Object {$_.emailAddresses -like $domain } | Select-Object PrimarySmtpAddress
foreach($mailbox in $mailboxes){ 
    Set-MailboxAutoReplyConfiguration -Identity $mailbox.PrimarySmtpAddress -AutoReplyState Enabled -InternalMessage "Enter your message here"

}

