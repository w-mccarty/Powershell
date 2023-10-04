$UserIdentity = "Username@Domain.com" #account to be disabled
$UserTenant = "tenant-id-for-the-user-in-question" #tenant id of the account to be disabled
$MyAdminAccount = "Admin@Domain.com" #your admin account for the tenant
#Convert to shared mailbox
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName "$($MyAdminAccount)"
$MailboxStatus = Get-Mailbox -Identity $UserIdentity
$MailboxStatus = $MailboxStatus.RecipientTypeDetails
if ($MailboxStatus -eq "UserMailbox") {
    Write-Host "Converting $($Useridentity) to a shared mailbox" -ForegroundColor Green
    Set-Mailbox -Identity $UserIdentity -Type Shared
} else {
    Write-Host "$($Useridentity) doesn't have a UserMailbox. $($MailboxStatus) was found." -ForegroundColor Red
}
Connect-MgGraph -TenantId "$($UserTenant)"
$FindUser = get-MgUser -ConsistencyLevel eventual -Search "UserPrincipalName:$($UserIdentity)"
$UsersId = $FindUser.Id
#disable user
Update-MgUser -UserId $UsersId -AccountEnabled:$false
Write-Host "$($Useridentity) disabled" -ForegroundColor Green
#revoke sessions
Revoke-MgUserSignInSession -UserId $UsersId
Write-Host "$($Useridentity) sessions revoked" -ForegroundColor Green
#remove licenses
$licencesToRemove = Get-MgUserLicenseDetail -UserId $UsersId | Select -ExpandProperty SkuId
Set-MgUserLicense -UserId $UsersId -RemoveLicenses $licencesToRemove -AddLicenses @{}
Write-Host "$($Useridentity) licenses removed" -ForegroundColor Green
#revoke registered devices
[array]$UserDevices = Get-MgUserRegisteredDevice -UserId $UsersId
If ($UserDevices) {
ForEach ($Device in $UserDevices) {
    Update-MgDevice -DeviceId $Device.Id -AccountEnabled $False}
}
Write-Host "$($Useridentity) registered devices session revoked" -ForegroundColor Green
