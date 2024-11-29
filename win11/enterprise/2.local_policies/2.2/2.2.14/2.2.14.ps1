# Title: Audit Script for 'Create symbolic links' Policy
# Description: This script checks if the 'Create symbolic links' policy is correctly configured.

Write-Host "Starting Audit: 'Create symbolic links' policy" -ForegroundColor Green

# Define the expected user rights assignment
$expectedSettingDefault = "Administrators"
$expectedSettingHyperV = "Administrators, NT VIRTUAL MACHINE\Virtual Machines"

# Get the current setting for 'Create symbolic links' policy
$currentSetting = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SeCreateSymbolicLinkPrivilege").Value

if ($currentSetting -eq $expectedSettingDefault) {
    Write-Host "PASS: 'Create symbolic links' is correctly set to '$expectedSettingDefault'." -ForegroundColor Green
} elseif ($currentSetting -eq $expectedSettingHyperV) {
    Write-Host "PASS: 'Create symbolic links' is correctly set to '$expectedSettingHyperV' (Hyper-V installed)." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Create symbolic links' is set to '$currentSetting'. It should be '$expectedSettingDefault' or '$expectedSettingHyperV' (for Hyper-V)." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

