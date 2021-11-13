#Initial Checks and Variables
if ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $false) {write-host "[**] Please run script as admin"; pause; exit}
cls
Write-Host "[**] Welcome to Roflsandwich Lag Switch, select the target process in the next window"
Read-Host "[**] Press enter continue"
$processName = (Get-Process | Out-GridView -Title "Select target process" -PassThru).Path.split('\')[-1]
cls
Write-Host "[**] Loaded process: $processName"
Write-Host "[**] Use CAPSLOCK to toggle lag switch"
#FUNCTIONS
function Toggle-Switch($switchParams){
    if ($switchParams[0] -eq $true -and $switchParams[1] -eq $false ){
        New-NetQosPolicy -Name "LagSwitch" -AppPathNameMatchCondition $switchParams[2] -ThrottleRateActionBitsPerSecond 8 -ErrorAction SilentlyContinue
        $switchStatus = $true;
        Write-Host -NoNewline "`r[**] Lag switch is RUNNING"    
    }elseif ($switchParams[0] -eq $false -and $switchParams[1] -ne $false){
        Remove-NetQosPolicy -Name "LagSwitch" -Confirm:$false -ErrorAction SilentlyContinue
        $switchStatus = $false
        Write-Host -NoNewline "`r[**] Lag switch is STOPPED"
    }
    return $switchStatus
}
#Main Loop
while ($true){
    $switchActivate = ([console]::CapsLock)
    $switchStatus = Toggle-Switch ($switchActivate, $switchStatus, $processName)
    sleep 1
}