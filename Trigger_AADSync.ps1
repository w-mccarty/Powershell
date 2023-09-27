#Runs Start-ADSyncSyncCycle if users,groups,or computers are created or deleted
#
# https://github.com/w-mccarty
#
#Install in C:\Sync
#Create dir C:\Sync\Log

#Enable users (yes/no), set OU, enable teams webhook (yes/no), set webhook URI
$Sync_Users = "yes"
$NewUserOU = "OU=Domain Users,DC=lab,DC=local"
$UserWebhook = "yes"
$UserURI = "<YOUR WEBHOOK URI HERE>"

#Enable groups (yes/no), set OU, enable teams webhook (yes/no), set webhook URI
$Sync_Groups = "yes"
$GroupOU = "OU=Domain Groups,DC=lab,DC=local"
$GroupWebhook = "yes"
$GroupURI = "<YOUR WEBHOOK URI HERE>"

#Enable computers (yes/no), set OU, enable teams webhook (yes/no), set webhook URI
$Sync_Computers = "no"
$ComputerOU = "OU=Domain Computers Hybrid,DC=lab,DC=local"
$ComputerWebhook = "yes"
$ComputerURI = "<YOUR WEBHOOK URI HERE>"

#log locations
$ScriptDir = "C:\Sync\Log"
$UserCSV = "$($ScriptDir)\Sync-userlist.csv"
$GroupCSV = "$($ScriptDir)\Sync-grouplist.csv"
$ComputerCSV = "$($ScriptDir)\Sync-computerlist.csv"
$LogFile = "$($ScriptDir)\Sync.log"

#dateformat
$LogDate = Get-Date -Format "yyyy-MM-dd-HH-mm"

#detect changes in users
if ($Sync_Users = "yes") {
    $Currentusers = Get-ADUser -SearchBase $NewUserOU -Filter * -Properties UserPrincipalName | Select-Object -Property UserPrincipalName
    if ($Currentusers -eq $null) {
        $Currentusers = ""
    }
    if (Test-path -Path $UserCSV) {
        if ((Import-Csv $UserCSV) -ne $null) {
            $UserDifferenceCSV = Import-Csv $UserCSV
            $UserDifference = Compare-Object -ReferenceObject ($UserDifferenceCSV) -DifferenceObject ($Currentusers) -Property UserPrincipalName
        } else {
        $Currentusers | Export-Csv -Path $UserCSV
        }
    } else {
        $Currentusers | Export-Csv -Path $UserCSV
    }
    if (($UserDifference -eq "") -or ($UserDifference -eq $null)) {
        $UserSync = $null
    } else {
        $UserSync = "true"
        $Currentusers | Export-Csv -Path $UserCSV
        $UserArray = [System.Collections.ArrayList]@()
        foreach ($UserDifferenceName in $UserDifference) {
            If ($UserDifferenceName.SideIndicator -eq "=>") {
                "$($LogDate),Added AD user,$($UserDifferenceName.UserPrincipalName)"  | Out-File -FilePath $LogFile -Append
                $UserArrayUpdate = $UserArray.Add("Added user $($UserDifferenceName.UserPrincipalName)<br>")
            } 
            If ($UserDifferenceName.SideIndicator -eq "<=") {
                "$($LogDate),Deleted AD user,$($UserDifferenceName.UserPrincipalName)" | Out-File -FilePath $LogFile -Append
                $UserArrayUpdate = $UserArray.Add("Deleted user $($UserDifferenceName.UserPrincipalName)<br>")
            }
        }
        if ($UserWebhook = "yes") {
            $UserTextdata = '{"title": "User Change Notification","text": "'+$UserArray+'"}'
            Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body $UserTextdata -Uri $UserURI
        }
    }
}

#detect changes in groups
if ($Sync_Groups = "yes") {
    $CurrentGroups = Get-ADGroup -SearchBase $GroupOU -Filter * -Properties * | Select-Object -Property CN
    if ($CurrentGroups -eq $null) {
        $CurrentGroups = ""
    }
    if (Test-path -Path $GroupCSV) {
        if ((Import-Csv $GroupCSV) -ne $null) {
            $GroupDifferenceCSV = Import-Csv $GroupCSV
            $GroupDifference = Compare-Object -ReferenceObject ($GroupDifferenceCSV) -DifferenceObject ($CurrentGroups) -Property CN
        } else {
            $CurrentGroups | Export-Csv -Path $GroupCSV
        }
    } else {
        $CurrentGroups | Export-Csv -Path $GroupCSV
    }
    if (($GroupDifference -eq "") -or ($GroupDifference -eq $null)) {
        $GroupSync = $null
    } else {
        $GroupSync = "true"
        $CurrentGroups | Export-Csv -Path $GroupCSV
        $GroupArray = [System.Collections.ArrayList]@()
        foreach ($GroupDifferenceName in $GroupDifference) {
            If ($GroupDifferenceName.SideIndicator -eq "=>") {
                "$($LogDate),Added group,$($GroupDifferenceName.CN)"  | Out-File -FilePath $LogFile -Append
                $GroupArrayUpdate = $GroupArray.Add("Added group $($GroupDifferenceName.CN)<br>")
            } 
            If ($GroupDifferenceName.SideIndicator -eq "<=") {
                "$($LogDate),Deleted group,$($GroupDifferenceName.CN)" | Out-File -FilePath $LogFile -Append
                $GroupArrayUpdate = $GroupArray.Add("Deleted group $($GroupDifferenceName.CN)<br>")
            }
        }
        if ($GroupWebhook = "yes") {
            $GroupTextdata = '{"title": "Group Change Notification","text": "'+$GroupArray+'"}'
            Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body $GroupTextdata -Uri $GroupURI
        }
    }
}

#detect changes in computers
if ($Sync_Computers = "yes") {
    $Currentcomputers = Get-ADComputer -SearchBase $ComputerOU -Filter * -Properties DistinguishedName | Select-Object -Property DistinguishedName
    if ($Currentcomputers -eq $null) {
        $Currentcomputers = ""
    }
    if (Test-path -Path $ComputerCSV) {
        if ((Import-Csv $ComputerCSV) -ne $null) {
            $ComputerDifferenceCSV = Import-Csv $ComputerCSV
            $ComputerDifference = Compare-Object -ReferenceObject ($ComputerDifferenceCSV) -DifferenceObject ($Currentcomputers) -Property DistinguishedName
        } Else {
            $Currentcomputers | Export-Csv -Path $ComputerCSV
        }
    } Else {
        $Currentcomputers | Export-Csv -Path $ComputerCSV
    }
    if (($ComputerDifference -eq "") -or ($ComputerDifference -eq $null)) {
        $ComputerSync = $null
    } else {
        $ComputerSync = "true"
        $Currentcomputers | Export-Csv -Path $ComputerCSV
		$ComputerArray = [System.Collections.ArrayList]@()
        foreach ($ComputerDifferenceDN in $ComputerDifference) {
            If ($ComputerDifferenceDN.SideIndicator -eq "=>") {
                "$($LogDate),Added computer,$($ComputerDifferenceDN.DistinguishedName)"  | Out-File -FilePath $LogFile -Append
				$ComputerArrayUpdate = $ComputerArray.Add("Added computer $($ComputerDifferenceDN.DistinguishedName)<br>")
            } 
            if ($ComputerDifferenceDN.SideIndicator -eq "<=") {
                "$($LogDate),Deleted computer,$($ComputerDifferenceDN.DistinguishedName)" | Out-File -FilePath $LogFile -Append
				$ComputerArrayUpdate = $ComputerArray.Add("Removed computer $($ComputerDifferenceDN.DistinguishedName)<br>")
            }
        }
		if ($ComputerWebhook = "yes") {
            $ComputerTextdata = '{"title": "Computer Change Notification","text": "'+$ComputerArray+'"}'
            Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body $ComputerTextdata -Uri $ComputerURI
        }
    }
}

#run Delta Sync if changes are detected and ADSyncCycle is not running
If (($UserSync -ne $null) -Or ($GroupSync -ne $null) -Or ($ComputerSync -ne $null)) {
    $ADSyncScheduler = Get-ADSyncScheduler
    If ($ADSyncScheduler.SyncCycleInProgress -eq $True) {
        Exit
    }
    Else {
        Start-ADSyncSyncCycle -PolicyType Delta
        Sleep 3
    }
}
