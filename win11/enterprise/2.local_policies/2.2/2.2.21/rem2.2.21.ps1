# Title: Remediation Script for 'Enable computer and user accounts to be trusted for delegation'
# Description: This script configures the 'Enable computer and user accounts to be trusted for delegation' policy to 'No One' as per CIS recommendations.

Write-Host "Starting Remediation: Configuring 'Enable computer and user accounts to be trusted for delegation' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Enable computer and user accounts to be trusted for delegation'
    Write-Host "Updating the policy to set 'No One'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeEnableDelegationPrivilege = ).*', ''

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Enable computer and user accounts to be trusted for delegation' policy is now configured correctly." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

