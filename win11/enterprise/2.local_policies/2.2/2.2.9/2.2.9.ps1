# Title: Audit Script for 'Change the time zone' Policy
# Description: This script checks if the 'Change the time zone' policy is set to 'Administrators, LOCAL SERVICE, Users'

Write-Host "Starting Audit: 'Change the time zone' policy" -ForegroundColor Green

# Define the expected user rights assignment
$expectedSetting = "Administrators, LOCAL SERVICE, Users"

# Get the current setting for 'Change the time zone' policy
$currentSetting = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SeTimeZonePrivilege").Value

if ($currentSetting -eq $expectedSetting) {
    Write-Host "PASS: 'Change the time zone' is correctly set to '$expectedSetting'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Change the time zone' is set to '$currentSetting'. It should be '$expectedSetting'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

