<#
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name PowerShellGet -Force
Install-Module -Name ExchangeOnlineManagement -Force
Update-Module -Name ExchangeOnlineManagement
Connect-ExchangeOnline
#>

#Find all maiboxes with forwarding configured...
Get-EXOMailbox -ResultSize unlimited -PropertySets All | select UserPrincipalName,ForwardingSmtpAddress | Where-Object {$_.ForwardingSmtpAddress -notlike $null}
