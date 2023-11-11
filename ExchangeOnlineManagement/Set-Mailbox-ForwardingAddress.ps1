#https://o365info.com/forward-mail-powershell-commands-quick/
#https://learn.microsoft.com/en-us/exchange/recipients/user-mailboxes/email-forwarding?view=exchserver-2019

Connect-ExchangeOnline

#-ForwardingAddress, the user will not know that the email sent is forwarded to another mailbox.
#-DeliverToMailboxAndForward parameter default is set to $False, meaning the messages are delivered only to the forwarding address. If the parameter is set to $True, messages will be delivered to the mailbox and the forwarding address.
Set-Mailbox -Identity "David.Kent@m365info.com" -ForwardingAddress "Amanda.Hansen@m365info.com" -DeliverToMailboxAndForward $True

#-ForwardingSmtpAddress to forward email to an internal or external mailbox. The user mailbox will know about the forwarding settings and can change this.
#-DeliverToMailboxAndForward parameter default is set to $False, meaning the messages are delivered only to the forwarding address. If the parameter is set to $True, messages will be delivered to the mailbox and the forwarding address.
Set-Mailbox -Identity "UPN" -ForwardingSmtpAddress "Forward Mailbox"

#Disable ForwardingAddress for specific mailbox
Set-Mailbox "David.Kent@m365info.com" -ForwardingAddress $null
Set-Mailbox "David.Kent@m365info.com" -ForwardingSmtpAddress $null

#####################

#Display forwarding information about specific mailbox
Get-Mailbox "UPN" | ft DisplayName, UserPrincipalName, ForwardingSmtpAddress, ForwardingAddress, DeliverToMailboxAndForward
Get-Mailbox "David.Kent@m365info.com" | ft DisplayName, UserPrincipalName, ForwardingSmtpAddress, ForwardingAddress, DeliverToMailboxAndForward

#Display list of all mailboxes with FowardingAddress and ForwardingSmtpAddress
Get-Mailbox -ResultSize Unlimited | Where { ($_.ForwardingAddress -ne $null) -or ($_.ForwardingSmtpAddress -ne $null) } | Select UserPrincipalName, ForwardingAddress, ForwardingSmtpAddress, DeliverToMailboxAndForward

#Export information about all forwarding addresses to CSV
Get-Mailbox -ResultSize Unlimited | Where-Object {$_.ForwardingAddress -ne $null -or $_.ForwardingSmtpAddress -ne $null } | Select-Object DisplayName, Alias, UserPrincipalName, ForwardingAddress, ForwardingSmtpAddress, DeliverToMailboxAndForward, RecipientType, RecipientTypeDetails | Export-Csv "C:\All Recipients Forwarding Addresses.csv" -NoTypeInformation -Encoding UTF8
