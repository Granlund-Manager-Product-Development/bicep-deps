# PowerShell code

########################################################
# Parameters
########################################################
[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,Position=1)]
    [ValidateLength(1,100)]
    [string]$Subscription,

    [Parameter(Mandatory=$True,Position=2)]
    [ValidateLength(1,100)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$True,Position=3)]
    [ValidateLength(1,100)]
    [string]$AnalysisServerName,
)

# Stop on all kinds of errors
$ErrorActionPreference = 'Stop'

# Keep track of time
$StartDate=(GET-DATE)



########################################################
# Log in to Azure with AZ (standard code)
########################################################
Write-Verbose -Message 'Connecting to Azure'

'Log in to Azure...'
Connect-AzAccount -Identity
#Connect-AzAccount -UseDeviceAuthentication -Subscription $Subscription
Select-AzSubscription -Subscription $Subscription


########################################################



########################################################
# Getting the AAS for testing and logging purposes
########################################################
$myAzureAnalysisServer = Get-AzAnalysisServicesServer -ResourceGroupName $ResourceGroupName -Name $AnalysisServerName
if (!$myAzureAnalysisServer)
{
    throw "$($AnalysisServerName) not found in $($ResourceGroupName)"
}
else
{
    Write-Output "Current status of $($AnalysisServerName): $($myAzureAnalysisServer.State)"
}



########################################################
# Restart AAS
########################################################
# tämä ei toimi, ei saatu selvyyttä asiaan, tehdään sitten restart stop/start yhdistelmällä
Write-Output "Now restarting $($AnalysisServerName)"
#$ApplicationCredential = Get-Credential
#Add-AzAnalysisServicesAccount -RolloutEnvironment "$ServerLocation.asazure.windows.net"
#Write-Output "Logged in"
$ret = Restart-AzAnalysisServicesInstance -Instance $myAzureAnalysisServer.ServerFullName -PassThru
if (!$ret)
{
  throw "Restart-AzAnalysisServicesAccount returned false"
}
Write-Output "Restarted"



########################################################
# Show when finished
########################################################
$Duration = NEW-TIMESPAN –Start $StartDate –End (GET-DATE)
Write-Output "Done in $([int]$Duration.TotalMinutes) minute(s) and $([int]$Duration.Seconds) second(s)"
