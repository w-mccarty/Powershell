<#
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name PowerShellGet -Force
Install-Module -Name ExchangeOnlineManagement -Force
Update-Module -Name ExchangeOnlineManagement
Connect-ExchangeOnline
#>

#Check for inbox rules involving movement or forwarding...
$UPNS = Get-EXOMailbox -ResultSize unlimited -RecipientTypeDetails UserMailbox,SharedMailbox -PropertySets All | select UserPrincipalName
foreach ($UPN in $UPNS) {
    $MailRules = Get-InboxRule -Mailbox $UPN.UserPrincipalName | select Name,Identity,Description,ForwardTo,ForwardAsAttachmentTo,RedirectTo,MarkAsRead,MoveToFolder,DeleteMessage
    foreach ($Prop in $MailRules) {
             if (($Prop.ForwardTo -ne $null) -or ($Prop.ForwardAsAttachmentTo -ne $null) -or ($Prop.RedirectTo -ne $null) -or ($Prop.MarkAsRead -ne "False") -or ($Prop.MarkAsRead -ne "False") -or ($Prop.MoveToFolder -ne $null) -or ($Prop.DeleteMessage -ne "False")) {
            [PsCustomObject]@{
                UPN                   = $UPN.UserPrincipalName
                RuleName              = $Prop.Name
                RuleDescription       = $Prop.Description
                RuleID                = $Prop.Identity
                ForwardTo             = $Prop.ForwardTo
                ForwardAsAttachmentTo = $Prop.ForwardAsAttachmentTo
                RedirectTo            = $Prop.RedirectTo
                MarkAsRead            = $Prop.MarkAsRead
                MoveToFolder          = $Prop.MoveToFolder
                DeleteMessage         = $Prop.DeleteMessage
            } 
        }   
    }
}
