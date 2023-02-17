$UserIdentity = "Username@Domain.com" #account to be disabled
$UserTenant = "tenant-id-for-the-user-in-question" #tenant id of the account to be disabled
$MyAdminAccount = "Admin@Domain.com" #your admin account for the tenant
#
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName "$($MyAdminAccount)"
$MailboxStatus = Get-Mailbox -Identity $UserIdentity
$MailboxStatus = $MailboxStatus.RecipientTypeDetails
if ($MailboxStatus -eq "UserMailbox") {
$MailboxStatus
Set-Mailbox -Identity $UserIdentity -Type Shared
Connect-MgGraph -TenantId "$($UserTenant)"
$FindUser = get-MgUser -ConsistencyLevel eventual -Search "UserPrincipalName:$($UserIdentity)"
$FindUser = $FindUser.Id
$licencesToRemove = Get-MgUserLicenseDetail -UserId $FindUser | Select -ExpandProperty SkuId
Set-MgUserLicense -UserId $FindUser -RemoveLicenses $licencesToRemove -AddLicenses @{}
Revoke-MgUserSign -UserId $FindUser
Update-MgUser -UserId $FindUser -AccountEnabled:$false
} else {
Write-Host "$($Useridentity) doesn't have a UserMailbox. $($MailboxStatus) was found." -ForegroundColor Red
}
