# Title: Audit Script for 'Create permanent shared objects' Policy
# Description: This script checks if the 'Create permanent shared objects' policy is correctly configured.

Write-Host "Starting Audit: 'Create permanent shared objects' policy" -ForegroundColor Green

# Define the expected user rights assignment
$expectedSetting = "No One"

# Get the current setting for 'Create permanent shared objects' policy
$currentSetting = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SeCreatePermanentPrivilege").Value

if ($currentSetting -eq $expectedSetting) {
    Write-Host "PASS: 'Create permanent shared objects' is correctly set to '$expectedSetting'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Create permanent shared objects' is set to '$currentSetting'. It should be '$expectedSetting'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

