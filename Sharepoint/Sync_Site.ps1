<#
odopen://sync/?siteId=<siteId>&webId=<webId>&webUrl=<webURL>&listId=<listId>&userEmail=<userEmail>&webTitle=<webTitle>&listTitle=<listTitle>

<siteId> is the SharePoint site siteId GUID, enclosed in curly brackets. 
You can get this GUID visiting 
https://<TenantName>.sharepoint.com/sites/<SiteName>/_api/site/id.

<webId> is the SharePoint site webId GUID, enclosed in curly brackets. 
You can get this GUID visiting 
https://<TenantName>.sharepoint.com/sites/<SiteName>/_api/web/id.

<webUrl> is the SharePoint site URL. 
You can get this URL visiting 
https://<TenantName>.sharepoint.com/sites/<SiteName>/_api/web/url.

<listId> is the SharePoint site documents library GUID, enclosed in curly brackets. 
You can get this GUID visiting the document library in the browser
Click in the gear icon and choosing "Library Settings". The URL will show the listId GUID at the end of URL i.e. 
https://<tenant>.sharepoint.com/sites/<SiteName>/_layouts/15/listedit.aspx?List=%7Bxxxxxxxx%7D (xxxxxxxx = GUID with escaped curly brackets)

<SiteName> is the name of the sharepoint site (can be set to anything you want)
<listTitle> is the name of the directory synced (can be set to anything you want)

<userEmail> is the OneDrive's user email address used to sign in into OneDrive.
#>

$SiteID = "{}"  
$WebID = "{}"
$WebURL = "https://<TenantName>.sharepoint.com/sites/<SiteName>"  
$ListID = "{}"
$SiteName = "test-11-7-23"
$listTitle = "test"

# Give Windows some time to load before getting the email address - useful for VM 
#Start-Sleep -s 20  
  
#$UserName = $env:USERNAME # use this for domain joined
#$userUPN= cmd /c "whoami /upn" # use this for AzureAD
$userUPN = "test@test.com" # use this for custom
 
Do{  
    $ODStatus = Get-Process onedrive -ErrorAction SilentlyContinue # Check to see if OneDrive is running  
    If ($ODStatus) { # If OneDrive is running start the sync. If not, loopback and check again  
        # Give OneDrive some time to start and authenticate before syncing library  
        #Start-Sleep -s 30  
        # set the path for odopen  
        $odopen = "odopen://sync/?siteId=" + $SiteID + "&webId=" + $WebID + "&webUrl=" + $webURL + "&listId=" + $ListID + "&userEmail=" + $userUPN + "&webTitle=" + $SiteName + "&listTitle=" + $listTitle
        #Start the sync  
        Start-Process $odopen 
    }
}  
Until ($ODStatus)
