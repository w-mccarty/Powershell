#Un-comment line 2 and 3 to install...
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#Install-Module Microsoft.Graph
Connect-MgGraph
$TenantID = Get-MgOrganization
$TenantID = $TenantID.Id
$TenantID
