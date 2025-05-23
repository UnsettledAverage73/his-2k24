# check.ps1
# Script to check if "Require domain users to elevate when setting a network's location" is enabled

# Registry key and expected value
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$RegValueName = "NC_StdDomainUserSetLocation"
$ExpectedValue = 1

# Check the registry key
if (Test-Path $RegPath) {
    $CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegValueName | Select-Object -ExpandProperty $RegValueName -ErrorAction SilentlyContinue
    if ($CurrentValue -eq $ExpectedValue) {
        Write-Output "Pass: Domain users are required to elevate when setting a network's location."
    } else {
        Write-Output "Fail: $RegValueName is set to $CurrentValue. Expected: $ExpectedValue."
    }
} else {
    Write-Output "Fail: Registry path $RegPath does not exist."
}
