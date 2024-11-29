# Check.ps1
# Description: Verifies if OpenSSH SSH Server (sshd) is Disabled or Not Installed.

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\sshd"
$regValue = "Start"
$expectedValue = 4

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValue

    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: OpenSSH SSH Server (sshd) is Disabled (`Start` = 4)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: OpenSSH SSH Server (sshd) is not set to Disabled (`Start` = 4). Current Value: $currentValue" -ForegroundColor Red
    }
} else {
    Write-Host "PASS: OpenSSH SSH Server (sshd) is not installed." -ForegroundColor Green
}
