#Script for shutting down / starting Analysis service
param(
    [Parameter(Mandatory=$True,Position=0)]
    [ValidateLength(1,100)]
    [string]$Subscription,

    [Parameter(Mandatory=$True,Position=1)]
    [ValidateLength(1,100)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$True,Position=2)]
    [ValidateLength(1,100)]
    [string]$AnalysisServerName,

    [Parameter(Mandatory=$True,Position=3)]
    [ValidateSet('Resume','Suspend','Restart')]
    [string]$AnalysisServiceCommand,
    )

Connect-AzAccount -Identity
Select-AzSubscription -Subscription $Subscription

$azuressas = Get-AzAnalysisServicesServer -Name $AnalysisServerName -ResourceGroupName $ResourceGroupName

if($AnalysisServiceCommand -eq "Resume")
{
  Write-host "Starting service...."
  Write-Output "Starting service...."
  Resume-AzAnalysisServicesServer `
  -Name $AnalysisServerName `
  -ResourceGroupName $ResourceGroupName

}
elseif($AnalysisServiceCommand -eq "Suspend") {
  Write-host "Stoping service...."
  Write-Output "Stoping service...."
  Suspend-AzAnalysisServicesServer `
  -Name $AnalysisServerName `
  -ResourceGroupName $ResourceGroupName

}
elseif($AnalysisServiceCommand -eq "Restart") {
  Write-host "Restarting service...."
  Write-Output "Restarting service...."
  $ret = Restart-AzAnalysisServicesServer `
  -Name $AnalysisServerName `
  -ResourceGroupName $ResourceGroupName
  if (!$ret)
  {
    throw "Restart-AzAnalysisServicesAccount returned false"
  }
}
