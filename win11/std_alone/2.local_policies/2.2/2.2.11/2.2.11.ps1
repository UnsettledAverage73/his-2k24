# Title: Audit Script for 'Create a token object' Policy
# Description: This script checks if the 'Create a token object' policy is set to 'No One'

Write-Host "Starting Audit: 'Create a token object' policy" -ForegroundColor Green

# Define the expected user rights assignment
$expectedSetting = "No One"

# Get the current setting for 'Create a token object' policy
$currentSetting = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SeCreateTokenPrivilege").Value

if ($currentSetting -eq $expectedSetting) {
    Write-Host "PASS: 'Create a token object' is correctly set to '$expectedSetting'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Create a token object' is set to '$currentSetting'. It should be '$expectedSetting'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

