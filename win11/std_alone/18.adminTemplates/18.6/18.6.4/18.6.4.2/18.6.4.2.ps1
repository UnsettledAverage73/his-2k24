# check.ps1
# Script to check if EnableNetbios is set to disable NetBIOS on public networks

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
$RegKey = "EnableNetbios"

# Check if the registry key exists
if (Test-Path "$RegPath\$RegKey") {
    $value = Get-ItemProperty -Path $RegPath -Name $RegKey | Select-Object -ExpandProperty $RegKey
    if ($value -eq 0 -or $value -eq 2) {
        Write-Output "Pass: NetBIOS name resolution is disabled on public networks."
    } else {
        Write-Output "Fail: EnableNetbios is set to $value. Remediation is required."
    }
} else {
    Write-Output "Fail: EnableNetbios registry key does not exist. Remediation is required."
}
