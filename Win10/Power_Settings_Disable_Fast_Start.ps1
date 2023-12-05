#Turn off quick start (1 = on, 0 = off)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Powers" -Name "HiberbootEnabled" -Value 0
