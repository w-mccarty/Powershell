#Runs Start-ADSyncSyncCycle if users,groups,or computers are created or deleted
#
# https://github.com/w-mccarty
#
#Install in C:\Scripts
#Create dir C:\Scripts\Log

#Enable users (yes/no) and set OU
$Sync_Users = "yes"
$NewUserOU = "OU=LAB Users,DC=lab,DC=internal"

#Enable groups (yes/no) and set OU
$Sync_Groups = "yes"
$GroupOU = "OU=LAB Groups,DC=lab,DC=internal"

#Enable computers (yes/no) and set OU
$Sync_Computers = "yes"
$ComputerOU = "OU=LAB Devices Hybrid,DC=lab,DC=internal"

#log locations
$ScriptDir = "C:\Scripts\Log"
$UserCSV = "$($ScriptDir)\Sync-userlist.csv"
$GroupCSV = "$($ScriptDir)\Sync-grouplist.csv"
$ComputerCSV = "$($ScriptDir)\Sync-computerlist.csv"
$LogFile = "$($ScriptDir)\Sync-log.log"

#dateformat
$LogDate = Get-Date -Format "yyyy-MM-dd-HH-mm"

#detect changes in users
if ($Sync_Users = "yes") {
    $Currentusers = Get-ADUser -SearchBase $NewUserOU -Filter * -Properties UserPrincipalName | Select-Object -Property UserPrincipalName
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
        foreach ($UserDifferenceName in $UserDifference) {
            If ($UserDifferenceName.SideIndicator -eq "=>") {
                "$($LogDate),Added user,$($UserDifferenceName.UserPrincipalName)"  | Out-File -FilePath $LogFile -Append
            } 
            If ($UserDifferenceName.SideIndicator -eq "<=") {
                "$($LogDate),Deleted user,$($UserDifferenceName.UserPrincipalName)" | Out-File -FilePath $LogFile -Append
            }
        }
    }
}

#detect changes in groups
if ($Sync_Groups = "yes") {
    $CurrentGroups = Get-ADGroup -SearchBase $GroupOU -Filter * -Properties * | Select-Object -Property CN
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
        foreach ($GroupDifferenceName in $GroupDifference) {
            If ($GroupDifferenceName.SideIndicator -eq "=>") {
                "$($LogDate),Added group,$($GroupDifferenceName.CN)"  | Out-File -FilePath $LogFile -Append
            } 
            If ($GroupDifferenceName.SideIndicator -eq "<=") {
                "$($LogDate),Deleted group,$($GroupDifferenceName.CN)" | Out-File -FilePath $LogFile -Append
            }
        }
    }
}

#detect changes in computers
if ($Sync_Computers = "yes") {
    $Currentcomputers = Get-ADComputer -SearchBase $ComputerOU -Filter * -Properties DistinguishedName | Select-Object -Property DistinguishedName
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
        foreach ($ComputerDifferenceDN in $ComputerDifference) {
            If ($ComputerDifferenceDN.SideIndicator -eq "=>") {
                "$($LogDate),Added computer,$($ComputerDifferenceDN.DistinguishedName)"  | Out-File -FilePath $LogFile -Append
            } 
            if ($ComputerDifferenceDN.SideIndicator -eq "<=") {
                "$($LogDate),Deleted computer,$($ComputerDifferenceDN.DistinguishedName)" | Out-File -FilePath $LogFile -Append
            }
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
