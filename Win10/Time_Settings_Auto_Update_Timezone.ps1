#BOTH settings must be turned on
#allow location
$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
Set-ItemProperty -Path $Path -Name "Value" -Value "Allow" #Deny = off, Allow = on
#enable timezone autoupdate
$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate"
Set-ItemProperty -Path $Path -Name "Start" -Value "3" #3 = on, 4 = off
