# Title: Remediation Script for 'Perform volume maintenance tasks' and 'Profile single process' Policies
# Description: This script sets the 'Perform volume maintenance tasks' and 'Profile single process' policies to 'Administrators'.

Write-Host "Starting Remediation: Configuring 'Perform volume maintenance tasks' and 'Profile single process' policies" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Perform volume maintenance tasks'
    Write-Host "Updating the policy for 'Perform volume maintenance tasks'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeManageVolumePrivilege = ).*', "Administrators"

    # Update the policy for 'Profile single process'
    Write-Host "Updating the policy for 'Profile single process'..." -ForegroundColor Cyan
    $updatedContent = $updatedContent -replace '(?<=SeProfileSingleProcessPrivilege = ).*', "Administrators"

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Perform volume maintenance tasks' and 'Profile single process' policies are now set to 'Administrators'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policies. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

