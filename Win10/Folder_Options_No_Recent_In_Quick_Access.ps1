$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$DWordName = 'ShowFrequent', 'ShowRecent'
foreach ($DWord in $DWordName) {
    $testpath = get-itempropertyvalue -path $location -name $DWord
    if (!($testpath)) {
        New-ItemProperty -Path $location -Name $DWord -Value 0 -PropertyType DWord -Force
    } else {
        New-ItemProperty -Path $location -Name $DWord -Value 0 -PropertyType DWORD -Force
    }
}
