$DomainURL = "" #for username@domain.com = domain.com
$CSVpath = "" #local path to create CSV file

write-host "connecting to MgGraph"
Connect-MgGraph -Scopes User.Read.All,Directory.Read.All,AuditLog.Read.All -NoWelcome

$USERS = get-mguser -Property Id, UserPrincipalName,SignInActivity | Where-Object {$_.UserPrincipalName.Contains($DomainURL)}

$LicenseTable = @{}
foreach ($USER in $USERS) {
    $USERUPN = $USER.UserPrincipalName
    $USERID = $USER.Id
    $Licenses = Get-MgUserLicenseDetail -UserId $USERID
    if ($Licenses -ne $null){
        $LicenseArray = $Licenses | ForEach-Object {$_.SkuPartNumber}
        $LicenseString = $LicenseArray -join ", "
        $LicenseTable.add($USERUPN, $LicenseString)
    } else {
    }
}
$NonInteractiveSignInDateTimeTABLE = @{}
foreach ($USER in $USERS) {
    $USERUPN = $USER.UserPrincipalName
    $NON = $USER.SignInActivity.LastNonInteractiveSignInDateTime
    if ($NON -ne $null) {
        $NonInteractiveSignInDateTimeTABLE.add($USERUPN, $NON)
    } else {
    }
}

$SignInDateTimeTABLE = @{}
foreach ($USER in $USERS) {
    $USERUPN = $USER.UserPrincipalName
    $SID = $USER.SignInActivity.LastSignInDateTime
    if ($SID -ne $null) {
        $SignInDateTimeTABLE.add($USERUPN, $SID)
    } else {
    }
}

write-host "connecting to ExchangeOnline"
Connect-ExchangeOnline -ShowBanner:$false
$DataTable2 = @{}
foreach ($key in $LicenseTable.Keys) { 
    $FORWARDING = Get-Mailbox -identity $key | Select UserPrincipalName,ForwardingSmtpAddress,DeliverToMailboxAndForward
    $RIGHTS = Get-Mailbox -identity $key | Get-MailboxPermission | Select User, AccessRights | Where {($_.user -ne "NT AUTHORITY\SELF")}
    if ($RIGHTS -ne $null) {
        $RIGHTS = $RIGHTS | ConvertTo-Json
        $RIGHTS = $RIGHTS -replace '\s','' -replace "`n",", " -replace "`r",", "    
    } else {
        $RIGHTS = "none"
    }
    if ($NonInteractiveSignInDateTimeTABLE.ContainsKey($key)) {
        $NonInteractiveSignInDateTime = $NonInteractiveSignInDateTimeTABLE.$key
    } else {
        $NonInteractiveSignInDateTime = "none"
    }
    if ($SignInDateTimeTABLE.ContainsKey($key )) {
        $SignInDateTime = $SignInDateTimeTABLE.$key
    } else {
        $SignInDateTime = "none"
    }
    if ($FORWARDING.ForwardingSmtpAddress -ne $null) {
        $FWD = $FORWARDING.ForwardingSmtpAddress
    } else {
        $FWD = "none"
    }
    $USERPROPERTIES = [pscustomobject][ordered]@{
            Username              = $key
            Licenses              = $DataTable.$key
            Interactive           = $SignInDateTime
            Noninteractive        = $NonInteractiveSignInDateTime
            ForardingSmtp         = $FWD
            ForwardingDeliverto   = $FORWARDING.DeliverToMailboxAndForward
            MailboxRights         = $RIGHTS
    }
    $USERPROPERTIES | Export-Csv -Path $CSVpath -Append -NoTypeInformation
}
write-host "done."
