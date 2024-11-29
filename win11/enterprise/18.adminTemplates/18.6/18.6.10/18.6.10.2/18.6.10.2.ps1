# check.ps1
# Script to check if "Turn off Microsoft Peer-to-Peer Networking Services" is enabled

# Registry key and expected value
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Peernet"
$RegValueName = "Disabled"
$ExpectedValue = 1

# Check the registry key
if (Test-Path $RegPath) {
    $CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegValueName | Select-Object -ExpandProperty $RegValueName -ErrorAction SilentlyContinue
    if ($CurrentValue -eq $ExpectedValue) {
        Write-Output "Pass: Microsoft Peer-to-Peer Networking Services are turned off as recommended."
    } else {
        Write-Output "Fail: $RegValueName is set to $CurrentValue. Expected: $ExpectedValue."
    }
} else {
    Write-Output "Fail: Registry path $RegPath does not exist."
}
