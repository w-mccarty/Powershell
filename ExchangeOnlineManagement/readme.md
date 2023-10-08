# ExchangeOnlineManagement

https://learn.microsoft.com/en-us/powershell/exchange/exchange-online-powershell?view=exchange-ps

### Install
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name PowerShellGet -Force
Install-Module -Name ExchangeOnlineManagement -Force
```

### Update
```
Update-Module -Name ExchangeOnlineManagement
Get-Module ExchangeOnlineManagement
```
### Connect
```
Connect-ExchangeOnline
#Disconnect-ExchangeOnline
```
