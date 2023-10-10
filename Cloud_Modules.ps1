#
#Connectable moduels - UPDATE THE FOLLOWING 3 Variables with module name, connect script, and URL for reference info
$Modules= 
    "Microsoft.Graph",
    "MicrosoftTeams",
    "Microsoft.Online.SharePoint.PowerShell",
    "Microsoft.Graph.Intune"
$Connect=
    "Connect-MgGraph -Scopes 'User.Read.All','Group.ReadWrite.All'",
    "Connect-MicrosoftTeams",
    "Connect-SPOService",
    "Connect-MSGraph"
$ReferenceInfo =
    "https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0",
    "https://learn.microsoft.com/en-us/powershell/sharepoint/sharepoint-online/connect-sharepoint-online",
    "https://learn.microsoft.com/en-us/microsoftteams/teams-powershell-install",
    "https://github.com/microsoft/Intune-PowerShell-SDK"
#
#Supporting non-connectable modules (DO NOT REMOVE)
$SupportingModules="PowerShellGet"
#
Function Main-Script(){
    Write-Host "$($Modules)" -ForegroundColor Gray
    Write-Host "Options... 1=connect, 2=install, 3=update, 4=info, uninstall=uninstall" -ForegroundColor Yellow
    $Input = Read-Host "enter option"
    if($Input -eq "1"){ #Connect
        Write-Host "Module number & Modules:" -ForegroundColor Gray
        for ($i = 0; $i -lt $Modules.Count; $i++) {
            Write-Host "$($i) = $($Modules[$i])" -ForegroundColor DarkYellow
        }
        $ConnectInput = Read-Host "enter module number to connect"
        if ($ConnectInput -ge 0 -And $ConnectInput -lt $Modules.Count){
            Write-Host "Connecting to $($Modules[$ConnectInput])" -ForegroundColor Green
            Invoke-Expression $Connect[$ConnectInput]
        } else {
            Write-Host "Option not found, returning to main screen" -BackgroundColor Red
            Main-Script
        }
    } ElseIf($Input -eq "2"){ #Install
        foreach ($Module in $SupportingModules){
            if(-not (Get-InstalledModule $Module)){
                Write-Host "installing $($Module)"
                Install-Module $Module -Scope CurrentUser -Force -AllowClobber
                $Version = Get-InstalledModule $Module
                $Version = $Version.Version
                Write-Host "$($Module) $($Version) installed" -ForegroundColor Green
            } else {
                $Version = Get-InstalledModule $Module
                $Version = $Version.Version
                Write-Host "$($Module) $($Version) already installed"
            }
        }
        foreach ($Module in $Modules){
            if(-not (Get-InstalledModule $Module)){
                Write-Host "installing $($Module)"
                Install-Module $Module -Scope CurrentUser -Force -AllowClobber
                $Version = Get-InstalledModule $Module
                $Version = $Version.Version
                Write-Host "$($Module) $($Version) installed" -ForegroundColor Green
            } else {
                $Version = Get-InstalledModule $Module
                $Version = $Version.Version
                Write-Host "$($Module) $($Version) already installed"
            }
        }
        Write-Host "ALL INSTALLATIONS COMPLETED" -BackgroundColor Green
        Main-Script
    } ElseIf($Input -eq "3"){ #Update
        foreach ($Module in $SupportingModules){
            if(-not (Get-InstalledModule $Module)){
                Write-Host "installing $($Module)"
                Install-Module $Module -Scope CurrentUser -Force -AllowClobber
                $Version = Get-InstalledModule $Module
                $Version = $Version.Version
                Write-Host "$($Module) $($Version) installed" -ForegroundColor Green
            } else {
                $Version = Get-InstalledModule $Module
                $Version = $Version.Version
                Write-Host "$($Module) $($Version) installed, updating module now"
                Update-Module Microsoft.Graph -Force
                $Version2 = Get-InstalledModule $Module
                $Version2 = $Version2.Version
                if($Version -eq $Version2){
                    Write-Host "$($Module) $($Version2) already latest version"
                } else {
                    Write-Host "$($Module) updated from version $($Version) to $($Version2)" -ForegroundColor Green
                }
            }
        }
        foreach ($Module in $Modules){
            if(-not (Get-InstalledModule $Module)){
                Write-Host "installing $($Module)"
                Install-Module $Module -Scope CurrentUser -Force -AllowClobber
                $Version = Get-InstalledModule $Module
                $Version = $Version.Version
                Write-Host "$($Module) $($Version) installed" -ForegroundColor Green
            } else {
                $Version = Get-InstalledModule $Module
                $Version = $Version.Version
                Write-Host "$($Module) $($Version) installed, updating module now"
                Update-Module Microsoft.Graph -Force
                $Version2 = Get-InstalledModule $Module
                $Version2 = $Version2.Version
                if($Version -eq $Version2){
                    Write-Host "$($Module) $($Version2) already latest version"
                } else {
                    Write-Host "$($Module) updated from version $($Version) to $($Version2)" -ForegroundColor Green
                }
            }
        }
        Write-Host "ALL UPDATES COMPLETED" -BackgroundColor Green
        Main-Script
    } ElseIf($Input -eq "4"){ #Information
        for ($i = 0; $i -lt $Modules.Count; $i++) {
            Write-Host "$($i) = $($Modules[$i])" -ForegroundColor DarkYellow
        }
        $InfoInput = Read-Host "enter module number for info"
        if ($InfoInput -ge 0 -And $InfoInput -lt $Modules.Count){
            Write-Host "Connecting to $($ReferenceInfo[$InfoInput])" -ForegroundColor Green
            Start-process -FilePath msedge -ArgumentList $ReferenceInfo[$InfoInput]
            Main-Script
        } else {
            Write-Host "Option not found, returning to main screen" -BackgroundColor Red
            Main-Script
        }
    } ElseIf($Input -eq "uninstall"){ #Uninstall
        Write-Host "WARNING - All modules will be uninstalled if confirmed" -BackgroundColor Red
        $UninstallInput = Read-Host "type yes to uninstall, no to quit"
        if($UninstallInput -eq "yes"){
            Write-Host "UNINSTALLING ALL MODULES" -BackgroundColor Red
            foreach ($Module in $Modules){
                Uninstall-Module $Module -AllVersions
            }
            Write-Host "ALL MODULES UNINSTALLED..." -BackgroundColor Red
            Main-Script
        } else {
            Write-Host "Operation canceled, returning to main screen" -BackgroundColor Red
            Main-Script
        }
    } else {
        Write-Host "Command not found, returning to main screen" -BackgroundColor Red
        Main-Script
    }
}
Main-Script



