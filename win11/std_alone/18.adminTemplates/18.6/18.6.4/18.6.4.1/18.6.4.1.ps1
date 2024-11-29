# check.ps1
# Script to check if DoHPolicy is set to Allow DoH (2) or Require DoH (3)

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
$RegKey = "DoHPolicy"

# Check if the registry key exists
if (Test-Path "$RegPath\$RegKey") {
    $value = Get-ItemProperty -Path $RegPath -Name $RegKey | Select-Object -ExpandProperty $RegKey
    if ($value -eq 2) {
        Write-Output "Pass: DoHPolicy is set to Allow DoH (2)."
    } elseif ($value -eq 3) {
        Write-Output "Pass: DoHPolicy is set to Require DoH (3)."
    } else {
        Write-Output "Fail: DoHPolicy is set to $value. Remediation is required."
    }
} else {
    Write-Output "Fail: DoHPolicy registry key does not exist. Remediation is required."
}
