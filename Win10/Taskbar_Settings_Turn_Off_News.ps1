#Turn off taskbar news and interests (0 = on, 2 = off)
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2
#restart explorer to finalize change
stop-process -name explorer –force
