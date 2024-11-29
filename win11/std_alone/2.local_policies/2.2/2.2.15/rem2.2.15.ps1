# Title: Remediation Script for 'Debug programs' Policy
# Description: This script configures the 'Debug programs' policy to be assigned to 'Administrators' as per the CIS benchmark.

Write-Host "Starting Remediation: Configuring 'Debug programs' policy" -ForegroundColor Yellow

# Define the expected user rights assignment
$expectedSetting = "Administrators"

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "C:\Windows\Security\Local Policies\export.inf"
    
    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $exportedContent = Get-Content "C:\Windows\Security\Local Policies\export.inf"

    # Update the policy for 'Debug programs' to include the expected setting
    Write-Host "Updating the policy to set 'Debug programs' to 'Administrators'..." -ForegroundColor Cyan
    $updatedContent = $exportedContent -replace '(?<=SeDebugPrivilege = ).*', $expectedSetting

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "C:\Windows\Security\Local Policies\import.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "C:\Windows\Security\Local Policies\import.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Debug programs' policy is now set to '$expectedSetting'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the 'Debug programs' policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

