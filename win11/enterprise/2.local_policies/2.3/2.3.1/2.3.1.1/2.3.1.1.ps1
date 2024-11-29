# Title: Audit Script for 'Accounts: Block Microsoft accounts' Policy
# Description: This script checks if the 'Accounts: Block Microsoft accounts' policy is set to 'Users can't add or log on with Microsoft accounts'.

Write-Host "Starting Audit: 'Accounts: Block Microsoft accounts' policy" -ForegroundColor Green

# Registry path and value name
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "NoConnectedUser"

# Expected value
$expectedValue = 3  # 'Users can't add or log on with Microsoft accounts'

# Check the current registry value
if (Test-Path "$regPath") {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regValueName -ErrorAction SilentlyContinue
    if ($currentValue -eq $expectedValue) {
        Write-Host "PASS: 'Accounts: Block Microsoft accounts' policy is correctly set to 'Users can't add or log on with Microsoft accounts'." -ForegroundColor Green
    } else {
        Write-Host "FAIL: 'Accounts: Block Microsoft accounts' policy is set to: $currentValue. It should be set to 'Users can't add or log on with Microsoft accounts'." -ForegroundColor Red
    }
} else {
    Write-Host "FAIL: Registry path $regPath does not exist." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

