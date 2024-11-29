# check.ps1
# Script to check if Enable Font Providers is disabled

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$RegKey = "EnableFontProviders"

# Check if the registry key exists
if (Test-Path "$RegPath\$RegKey") {
    $value = Get-ItemProperty -Path $RegPath -Name $RegKey | Select-Object -ExpandProperty $RegKey
    if ($value -eq 0) {
        Write-Output "Pass: Font Providers are disabled."
    } else {
        Write-Output "Fail: EnableFontProviders is set to $value. Remediation is required."
    }
} else {
    Write-Output "Fail: EnableFontProviders registry key does not exist. Remediation is required."
}
