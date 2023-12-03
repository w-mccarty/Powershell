#modified from https://gist.github.com/jamiechalmerzlp/13ab5618e75326fe5e444ec660c195be

$RegKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'
$ImageValue = 'C:\background.jpg'
 
if (!(Test-Path $RegKeyPath)) {
	New-Item -Path $RegKeyPath -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "DesktopImageStatus" -Value '1' -PropertyType DWORD -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageStatus" -Value '1' -PropertyType DWORD -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "DesktopImagePath" -Value $ImageValue -PropertyType STRING -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "DesktopImageUrl" -Value $ImageValue -PropertyType STRING -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "LockScreenImagePath" -Value $ImageValue -PropertyType STRING -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageUrl" -Value $ImageValue -PropertyType STRING -Force | Out-Null
} else {
	New-ItemProperty -Path $RegKeyPath -Name "DesktopImageStatus" -Value '1' -PropertyType DWORD -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageStatus" -Value '1' -PropertyType DWORD -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "DesktopImagePath" -Value $ImageValue -PropertyType STRING -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "DesktopImageUrl" -Value $ImageValue -PropertyType STRING -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "LockScreenImagePath" -Value $ImageValue -PropertyType STRING -Force | Out-Null
	New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageUrl" -Value $ImageValue -PropertyType STRING -Force | Out-Null
}
stop-process -Name explorer -Force
