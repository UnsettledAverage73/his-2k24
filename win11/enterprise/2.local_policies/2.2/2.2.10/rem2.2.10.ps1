# Title: Remediation Script for 'Create a pagefile' Policy
# Description: This script configures the 'Create a pagefile' policy to 'Administrators'

Write-Host "Starting Remediation: Setting 'Create a pagefile' policy" -ForegroundColor Yellow

# Define the expected user rights assignment
$expectedSetting = "Administrators"

try {
    # Apply the recommended configuration
    secedit /export /cfg "C:\Windows\Security\Local Policies\export.inf"
    $exportedContent = Get-Content "C:\Windows\Security\Local Policies\export.inf"
    $updatedContent = $exportedContent -replace '(?<=SeCreatePagefilePrivilege = ).*', $expectedSetting
    $updatedContent | Set-Content "C:\Windows\Security\Local Policies\import.inf"

    secedit /configure /db secedit.sdb /cfg "C:\Windows\Security\Local Policies\import.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Create a pagefile' policy is now set to '$expectedSetting'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the 'Create a pagefile' policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

