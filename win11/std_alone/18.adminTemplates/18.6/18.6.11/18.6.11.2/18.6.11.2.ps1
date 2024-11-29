# check.ps1
# Script to check if "Prohibit installation and configuration of Network Bridge on your DNS domain network" is enabled

# Registry key and expected value
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$RegValueName = "NC_AllowNetBridge_NLA"
$ExpectedValue = 0

# Check the registry key
if (Test-Path $RegPath) {
    $CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegValueName | Select-Object -ExpandProperty $RegValueName -ErrorAction SilentlyContinue
    if ($CurrentValue -eq $ExpectedValue) {
        Write-Output "Pass: Network Bridge installation and configuration is prohibited as recommended."
    } else {
        Write-Output "Fail: $RegValueName is set to $CurrentValue. Expected: $ExpectedValue."
    }
} else {
    Write-Output "Fail: Registry path $RegPath does not exist."
}
