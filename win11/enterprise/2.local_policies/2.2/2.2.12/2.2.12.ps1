# Title: Audit Script for 'Create global objects' Policy
# Description: This script checks if the 'Create global objects' policy is correctly configured.

Write-Host "Starting Audit: 'Create global objects' policy" -ForegroundColor Green

# Define the expected user rights assignment
$expectedSetting = "Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE"

# Get the current setting for 'Create global objects' policy
$currentSetting = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SeCreateGlobalPrivilege").Value

if ($currentSetting -eq $expectedSetting) {
    Write-Host "PASS: 'Create global objects' is correctly set to '$expectedSetting'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Create global objects' is set to '$currentSetting'. It should be '$expectedSetting'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

