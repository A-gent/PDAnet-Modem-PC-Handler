
Add-Type -AssemblyName System.Runtime.WindowsRuntime
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
Function Await($WinRtTask, $ResultType) {
    $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    $netTask = $asTask.Invoke($null, @($WinRtTask))
    $netTask.Wait(-1) | Out-Null
    $netTask.Result
}
Function AwaitAction($WinRtAction) {
    $asTask = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and !$_.IsGenericMethod })[0]
    $netTask = $asTask.Invoke($null, @($WinRtAction))
    $netTask.Wait(-1) | Out-Null
}
function write_logFile{
    Param ([string]$log_file, $log_message)
    $time_stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $log_message += $time_stamp
    $log_message | Out-File -FilePath $log_file -Append
}

$connectionProfile = [Windows.Networking.Connectivity.NetworkInformation,Windows.Networking.Connectivity,ContentType=WindowsRuntime]::GetInternetConnectionProfile()
$tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager,Windows.Networking.NetworkOperators,ContentType=WindowsRuntime]::CreateFromConnectionProfile($connectionProfile)



# Check whether Mobile Hotspot is enabled
$hotspotpulse1 = $tetheringManager.TetheringOperationalState

# Stop Mobile Hotspot
$hotspotpulse2 = Await ($tetheringManager.StopTetheringAsync()) ([Windows.Networking.NetworkOperators.NetworkOperatorTetheringOperationResult])

write_logFile -log_file "C:\Users\thann\Documents\ChainOverflow\hotspot_state.log" -log_message $hotspotpulse1
write_logFile -log_file "C:\Users\thann\Documents\ChainOverflow\hotspot_state.log" -log_message $hotspotpulse2
Get-Content "C:\Users\thann\Documents\ChainOverflow\hotspot_state.log"

# PAUSE
EXIT