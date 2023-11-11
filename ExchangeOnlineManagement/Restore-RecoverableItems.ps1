#https://learn.microsoft.com/en-us/exchange/recipients-in-exchange-online/manage-user-mailboxes/recover-deleted-messages
#https://www.capisani.com.au/blog/posts/2021/june/spo-restoring-over-100k-items-from-recycle-bin/

Connect-ExchangeOnline
$UPN = "test@test.com"

#find recoverables
Get-RecoverableItems -Identity $UPN -SubjectContains "FY17 Accounting" -FilterItemType IPM.Note -FilterStartTime "2/1/2018 12:00:00 AM" -FilterEndTime "2/5/2018 11:59:59 PM"

#restore recoverables
$SUBJECT = "COGS FY17 Review"
Restore-RecoverableItems -Identity $UPN -FilterItemType IPM.Note -SubjectContains $SUBJECT -FilterStartTime "3/15/2019 12:00:00 AM" -FilterEndTime "3/25/2019 11:59:59 PM"
