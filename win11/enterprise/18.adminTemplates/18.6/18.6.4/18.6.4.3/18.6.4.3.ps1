# check.ps1
# Script to check if Turn off multicast name resolution is enabled

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
$RegKey = "EnableMulticast"

# Check if the registry key exists
if (Test-Path "$RegPath\$RegKey") {
    $value = Get-ItemProperty -Path $RegPath -Name $RegKey | Select-Object -ExpandProperty $RegKey
    if ($value -eq 0) {
        Write-Output "Pass: Multicast name resolution is turned off (LLMNR is disabled)."
    } else {
        Write-Output "Fail: EnableMulticast is set to $value. Remediation is required."
    }
} else {
    Write-Output "Fail: EnableMulticast registry key does not exist. Remediation is required."
}
