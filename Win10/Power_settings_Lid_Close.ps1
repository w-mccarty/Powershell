# Query WMI to obtain active power plan, parse and output only GUID to variable
$Plan = Get-WmiObject -Class Win32_PowerPlan -Namespace root\cimv2\power -Filter "IsActive= 'True'"
$Regex = [regex] "{(.*?)}$"
$PlanGuid = $Regex.Match($Plan.InstanceID.ToString()).Groups[1].Value
#powercfg -Q $PlanGUID #list all power settings
    $Subgroup_GUID = '4f971e89-eebd-4455-a8de-9e59040e7347' #(Power buttons and lid)
    $Power_Setting_GUID = '5ca83367-6e45-459f-a27b-476b1d01c936'  #(Lid close action)
    #0=nothing, 1=sleep, 2=hibernate, 3=shutdown
    powercfg -SETACVALUEINDEX $PlanGUID $Subgroup_GUID $Power_Setting_GUID 0
    powercfg -SETDCVALUEINDEX $PlanGUID $Subgroup_GUID $Power_Setting_GUID 2
