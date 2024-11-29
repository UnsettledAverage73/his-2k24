# check.ps1
# Script to check if Enable insecure guest logons is disabled

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation"
$RegKey = "AllowInsecureGuestAuth"

# Check if the registry key exists
if (Test-Path "$RegPath\$RegKey") {
    $value = Get-ItemProperty -Path $RegPath -Name $RegKey | Select-Object -ExpandProperty $RegKey
    if ($value -eq 0) {
        Write-Output "Pass: Insecure guest logons are disabled."
    } else {
        Write-Output "Fail: AllowInsecureGuestAuth is set to $value. Remediation is required."
    }
} else {
    Write-Output "Fail: AllowInsecureGuestAuth registry key does not exist. Remediation is required."
}
