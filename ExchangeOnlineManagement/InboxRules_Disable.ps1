<#
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name PowerShellGet -Force
Install-Module -Name ExchangeOnlineManagement -Force
Update-Module -Name ExchangeOnlineManagement
Connect-ExchangeOnline
#>

#Disable Inbox Rules
$UserIdentity = ""
$RuleIdentity = ""
Disable-InboxRule -Identity $RuleIdentity -Mailbox $UserIdentity
