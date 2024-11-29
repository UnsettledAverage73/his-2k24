# check.ps1
# Script to audit the setting of "Enable Windows NTP Client"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\W32Time\TimeProviders\NtpClient"
$regValue = "Enabled"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 1) {
            Write-Output "PASS: 'Enable Windows NTP Client' is set to Enabled."
        } else {
            Write-Output "FAIL: 'Enable Windows NTP Client' is not set to Enabled."
        }
    } else {
        Write-Output "FAIL: 'Enable Windows NTP Client' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
