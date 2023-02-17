#One liner to prepend last write time ONLY to directories and subdirectories:
 Get-ChildItem -Recurse -Directory | ForEach-Object {Rename-Item $_.fullname -NewName ("{0}-{1}{2}" -f $_.LastWriteTime.ToString('yyyy-MM-dd'),$_.BaseName,$_.Extension)} 
 
 #One liner to prepend last write time to ONLY files and files in subdirectories
  Get-ChildItem -Recurse | where { !$_.PSisContainer } | ForEach-Object {Rename-Item $_.fullname -NewName ("{0}-{1}{2}" -f $_.LastWriteTime.ToString('yyyy-MM-dd'),$_.BaseName,$_.Extension)} 
  
  #One liner to prepend last write time to ALL files, directories, subdirectories, and files in subdirectories:
  Get-ChildItem -Recurse | ForEach-Object {Rename-Item $_.fullname -NewName ("{0}-{1}{2}" -f $_.LastWriteTime.ToString('yyyy-MM-dd'),$_.BaseName,$_.Extension)} 
  
  #If you wanted to break the last bit of code out to specify a directory you could do the following: 
$myPath = 'C:\dir'
$toRename = Get-ChildItem $myPath -Recurse
$toRename | ForEach-Object {
Rename-Item $_.fullname -NewName ("{0}-{1}{2}" -f $_.LastWriteTime.ToString('yyyy-MM-dd'),$_.BaseName,$_.Extension)
}

#Additionally, by adjusting the order of the items in -NewName you append. "{0}-{1}{2}" prepends, "{1}-{0}{2}" appends. Other properties can be used instead of ".LastWriteTime," such as ".CreationTime." 
