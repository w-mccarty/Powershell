#credit to https://stackoverflow.com/a/69188962
# Set up the parameters for Set-ItemProperty
$sipParams = @{
  Path  = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
  Name  = 'LaunchTo'
  Value = 1 # Set the LaunchTo value for "This PC"
}
# Run Set-ItemProperty with the parameters we set above
Set-ItemProperty @sipParams
