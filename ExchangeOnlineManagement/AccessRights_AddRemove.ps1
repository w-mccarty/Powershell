<#
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name PowerShellGet -Force
Install-Module -Name ExchangeOnlineManagement -Force
Update-Module -Name ExchangeOnlineManagement
Connect-ExchangeOnline
#>

$UserToAccess = "YOURUPN"
$UserAccessing = "UPN_OF_ACCESSING_USER"
$Right = "" #ChangeOwner,ChangePermission,DeleteItemExternalAccountFullAccess,ReadPermission

#Add access rights
Add-MailboxPermission –Identity $UserToAccess –User $UserAccessing –AccessRights $Right -InheritanceType All -Confirm:$false

#Remove access rights
#Remove-MailboxPermission -Identity $UserToAccess -User $UserAccessing -AccessRights $Right -InheritanceType All -Confirm:$false
