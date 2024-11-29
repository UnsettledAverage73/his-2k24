# check.ps1
# Script to check if "Prohibit use of Internet Connection Sharing on your DNS domain network" is enabled

# Registry key and expected value
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$RegValueName = "NC_ShowSharedAccessUI"
$ExpectedValue = 0

# Check the registry key
if (Test-Path $RegPath) {
    $CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegValueName | Select-Object -ExpandProperty $RegValueName -ErrorAction SilentlyContinue
    if ($CurrentValue -eq $ExpectedValue) {
        Write-Output "Pass: Internet Connection Sharing is prohibited as recommended."
    } else {
        Write-Output "Fail: $RegValueName is set to $CurrentValue. Expected: $ExpectedValue."
    }
} else {
    Write-Output "Fail: Registry path $RegPath does not exist."
}
