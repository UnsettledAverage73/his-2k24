# check.ps1
# Script to audit the setting of "Require a password when a computer wakes (plugged in)"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5f7d2daa51f51"
$regValue = "ACSettingIndex"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 1) {
            Write-Output "PASS: 'Require a password when a computer wakes (plugged in)' is set to Enabled."
        } else {
            Write-Output "FAIL: 'Require a password when a computer wakes (plugged in)' is set to Disabled."
        }
    } else {
        Write-Output "FAIL: 'Require a password when a computer wakes (plugged in)' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
