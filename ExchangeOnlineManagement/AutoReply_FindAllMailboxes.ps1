<#
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name PowerShellGet -Force
Install-Module -Name ExchangeOnlineManagement -Force
Update-Module -Name ExchangeOnlineManagement
Connect-ExchangeOnline
#>

#https://learn.microsoft.com/en-us/powershell/module/exchange/set-mailboxautoreplyconfiguration?view=exchange-ps

$UserIdentity = "UPN"
$Internal = "<html><body> MESSAGE TEXT </body></html>"
$External = "<html><body> MESSAGE TEXT </body></html>"

#Enable OOO
Set-MailboxAutoReplyConfiguration -Identity $UserIdentity -AutoReplyState Enabled -InternalMessage $Internal -ExternalMessage $External -ExternalAudience All

#Disable OOO
#Set-MailboxAutoReplyConfiguration -Identity $UserIdentity -AutoReplyState Disabled -InternalMessage $Internal -ExternalMessage $External -ExternalAudience All
