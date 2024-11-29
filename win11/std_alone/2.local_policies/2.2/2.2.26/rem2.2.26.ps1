# Title: Remediation Script for 'Load and unload device drivers' Policy
# Description: This script sets the 'Load and unload device drivers' policy to 'Administrators' as per CIS recommendations.

Write-Host "Starting Remediation: Configuring 'Load and unload device drivers' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Load and unload device drivers' to the expected value
    Write-Host "Updating the policy to 'Administrators'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeLoadDriverPrivilege = ).*', '*S-1-5-32-544'

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Load and unload device drivers' policy is now configured to 'Administrators'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

