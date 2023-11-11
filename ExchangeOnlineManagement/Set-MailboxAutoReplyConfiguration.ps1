#https://learn.microsoft.com/en-us/powershell/module/exchange/set-mailboxautoreplyconfiguration?view=exchange-ps
#https://www.alitajran.com/set-automatic-replies-with-powershell/
    
Connect-ExchangeOnline
$UPN = "test@test.com"

#internal and external
Set-MailboxAutoReplyConfiguration -Identity $UPN -AutoReplyState Enabled -InternalMessage "Internal auto-reply test." -ExternalMessage "External auto-reply test." -ExternalAudience All

#internal and contact list ONLY
Set-MailboxAutoReplyConfiguration -Identity $UPN -AutoReplyState Enabled -ExternalMessage "External auto-reply test only contacts." -ExternalAudience Known

#internal only
Set-MailboxAutoReplyConfiguration -Identity $UPN -AutoReplyState Enabled -InternalMessage "Internal auto-reply test." -ExternalMessage $null -ExternalAudience None

####################################################################################

#disable
Set-MailboxAutoReplyConfiguration -Identity $UPN -AutoreplyState Disabled

#disable and clear
Set-MailboxAutoReplyConfiguration -Identity "James.Paterson@exoip.com" -AutoReplyState Disabled -ExternalAudience All -ExternalMessage $null -InternalMessage $null

####################################################################################

#Use CSV with header User,InternalMessage to configure multiple at once
Connect-ExchangeOnline
$User = Import-Csv C:\importautoreply.csv 
foreach($user in $user){
    Write-Progress -Activity "Adding auto-reply message to -$user..."
    Set-MailboxAutoreplyConfiguration -Identity $User.User -AutoReplyState Enabled -Internalmessage $User.InternalMessage
    If($?) {
        Write-Host Auto-reply message successfully added to $User.user -ForegroundColor Green
    } Else {
        Write-Host Error occurred while adding auto-reply message to $User.user -ForegroundColor Red
    }
}
