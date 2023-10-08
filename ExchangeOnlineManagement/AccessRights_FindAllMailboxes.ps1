<#
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name PowerShellGet -Force
Install-Module -Name ExchangeOnlineManagement -Force
Update-Module -Name ExchangeOnlineManagement
Connect-ExchangeOnline
#>

#Find all maiboxes with access rights configured...
$UPNS = Get-EXOMailbox -ResultSize unlimited -RecipientTypeDetails UserMailbox,SharedMailbox -PropertySets All | select UserPrincipalName #| Where-Object {$_.UserPrincipalName -notlike "DiscoverySearchMailbox*"}
foreach ($UPN in $UPNS) {
    $UserRights = Get-EXOMailboxPermission -Identity $UPN.UserPrincipalName | select User,AccessRights | Where-Object {$_.User -notlike "NT AUTHORITY\SELF"}
    foreach ($UserRight in $UserRights) {
        [PsCustomObject]@{
            UPN           = $UPN.UserPrincipalName
            AccessRight   = $UserRights.AccessRights
            ToUser        = $UserRights.User
            } 
        }
}
