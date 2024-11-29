# check.ps1
# Script to audit the setting of "Enable Windows NTP Server"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\W32Time\TimeProviders\NtpServer"
$regValue = "Enabled"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 0) {
            Write-Output "PASS: 'Enable Windows NTP Server' is set to Disabled."
        } else {
            Write-Output "FAIL: 'Enable Windows NTP Server' is not set to Disabled."
        }
    } else {
        Write-Output "FAIL: 'Enable Windows NTP Server' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
