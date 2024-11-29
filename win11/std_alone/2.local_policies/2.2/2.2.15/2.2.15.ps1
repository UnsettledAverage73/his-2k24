# Title: Audit Script for 'Debug programs' Policy
# Description: This script checks if the 'Debug programs' policy is set to 'Administrators' as recommended by the CIS benchmark.

Write-Host "Starting Audit: 'Debug programs' policy" -ForegroundColor Green

# Define the expected user rights assignment
$expectedSetting = "Administrators"

# Retrieve the current setting for 'Debug programs' policy
$currentSetting = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SeDebugPrivilege").Value

# Check if the current setting matches the expected value
if ($currentSetting -eq $expectedSetting) {
    Write-Host "PASS: 'Debug programs' is correctly set to '$expectedSetting'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Debug programs' is set to '$currentSetting'. It should be '$expectedSetting'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

