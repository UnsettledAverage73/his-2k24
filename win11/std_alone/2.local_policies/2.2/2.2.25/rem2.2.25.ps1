# Title: Remediation Script for 'Increase scheduling priority' Policy
# Description: This script sets the 'Increase scheduling priority' policy to 'Administrators, Window Manager\Window Manager Group' as per CIS recommendations.

Write-Host "Starting Remediation: Configuring 'Increase scheduling priority' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Increase scheduling priority' to the expected values
    Write-Host "Updating the policy to 'Administrators, Window Manager\Window Manager Group'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeIncreaseBasePriorityPrivilege = ).*', '*S-1-5-32-544,*S-1-5-90-0'

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Increase scheduling priority' policy is now configured to 'Administrators, Window Manager\Window Manager Group'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

