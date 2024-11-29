# Title: Remediation Script for 'Change the time zone' Policy
# Description: This script configures the 'Change the time zone' policy to 'Administrators, LOCAL SERVICE, Users'

Write-Host "Starting Remediation: Setting 'Change the time zone' policy" -ForegroundColor Yellow

# Define the expected user rights assignment
$expectedSetting = "Administrators, LOCAL SERVICE, Users"

try {
    # Apply the recommended configuration
    secedit /export /cfg "C:\Windows\Security\Local Policies\export.inf"
    $exportedContent = Get-Content "C:\Windows\Security\Local Policies\export.inf"
    $updatedContent = $exportedContent -replace '(?<=SeTimeZonePrivilege = ).*', $expectedSetting
    $updatedContent | Set-Content "C:\Windows\Security\Local Policies\import.inf"

    secedit /configure /db secedit.sdb /cfg "C:\Windows\Security\Local Policies\import.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Change the time zone' policy is now set to '$expectedSetting'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the 'Change the time zone' policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

