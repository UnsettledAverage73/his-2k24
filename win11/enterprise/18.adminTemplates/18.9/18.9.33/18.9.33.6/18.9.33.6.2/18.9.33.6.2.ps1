# check.ps1
# Script to audit the setting of "Allow network connectivity during connected-standby (plugged in)"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9"
$regValue = "ACSettingIndex"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 0) {
            Write-Output "PASS: 'Allow network connectivity during connected-standby (plugged in)' is set to Disabled."
        } else {
            Write-Output "FAIL: 'Allow network connectivity during connected-standby (plugged in)' is set to Enabled."
        }
    } else {
        Write-Output "FAIL: 'Allow network connectivity during connected-standby (plugged in)' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
