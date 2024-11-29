# check.ps1
# Script to audit the setting of "Allow standby states (S1-S3) when sleeping (plugged in)"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\abfc2519-3608-4c2a-94ea171b0ed546ab"
$regValue = "ACSettingIndex"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 0) {
            Write-Output "PASS: 'Allow standby states (S1-S3) when sleeping (plugged in)' is set to Disabled."
        } else {
            Write-Output "FAIL: 'Allow standby states (S1-S3) when sleeping (plugged in)' is set to Enabled."
        }
    } else {
        Write-Output "FAIL: 'Allow standby states (S1-S3) when sleeping (plugged in)' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
