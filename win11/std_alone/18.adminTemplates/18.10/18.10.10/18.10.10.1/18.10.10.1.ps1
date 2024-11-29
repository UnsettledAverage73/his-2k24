# check.ps1
# Script to audit the setting of "Allow Use of Camera" and ensure it's set to Disabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Camera"
$regValue = "AllowCamera"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 0) {
            Write-Output "PASS: 'Allow Use of Camera' is set to Disabled."
        } else {
            Write-Output "FAIL: 'Allow Use of Camera' is not set to Disabled."
        }
    } else {
        Write-Output "FAIL: 'Allow Use of Camera' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
