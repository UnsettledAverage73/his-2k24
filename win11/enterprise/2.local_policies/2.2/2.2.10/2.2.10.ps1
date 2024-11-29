# Title: Audit Script for 'Create a pagefile' Policy
# Description: This script checks if the 'Create a pagefile' policy is set to 'Administrators'

Write-Host "Starting Audit: 'Create a pagefile' policy" -ForegroundColor Green

# Define the expected user rights assignment
$expectedSetting = "Administrators"

# Get the current setting for 'Create a pagefile' policy
$currentSetting = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SeCreatePagefilePrivilege").Value

if ($currentSetting -eq $expectedSetting) {
    Write-Host "PASS: 'Create a pagefile' is correctly set to '$expectedSetting'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Create a pagefile' is set to '$currentSetting'. It should be '$expectedSetting'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

