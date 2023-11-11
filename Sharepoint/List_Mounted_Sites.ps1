#Modified from & credit to:
#https://www.cloudpilot.no/blog/List-all-your-syncronized-libraries-in-OneDrive-for-Business-using-PowerShell/
#
$ODfBSync = Get-ChildItem -Path Registry::HKEY_CURRENT_USER\SOFTWARE\SyncEngines\Providers\OneDrive
    $Items = $ODfBSync | Where-Object {$_.Name -notmatch "Personal"} | ForEach-Object { Get-ItemProperty $_.PsPath }  
    $AllODfBLibs = [System.Collections.ArrayList]@()
    ForEach ($Item in $Items) {
        $Obj = New-Object PSCustomObject
        $ODfBLib = [ordered]@{
            Url              = $Item.UrlNamespace
            MountPoint       = $Item.MountPoint
            LibraryType       = $Item.LibraryType
            LastModifiedTime = $(if ($Item.LastModifiedTime -as [DateTime]) { [datetime]::Parse($Item.LastModifiedTime) } else { $_ })
        }
        $Obj | Add-Member -MemberType NoteProperty -Name Url -Value $ODfBLib.Url
        $Obj | Add-Member -MemberType NoteProperty -Name MountPoint -Value $ODfBLib.MountPoint
        $Obj | Add-Member -MemberType NoteProperty -Name LibraryType -Value (Get-Culture).TextInfo.ToTitleCase($ODfBLib.LibraryType)
        $Obj | Add-Member -MemberType NoteProperty -Name LastModifiedTime -Value $ODfBLib.LastModifiedTime   
        $AllODfBLibs += $Obj   
    }
return $AllODfBLibs | Sort-Object LibraryType | Format-List
