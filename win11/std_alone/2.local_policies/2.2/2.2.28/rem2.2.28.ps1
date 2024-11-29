# Title: Remediation Script for 'Log on as a batch job' Policy
# Description: This script sets the 'Log on as a batch job' policy to 'Administrators' as per CIS recommendations.

Write-Host "Starting Remediation: Configuring 'Log on as a batch job' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Log on as a batch job' to 'Administrators'
    Write-Host "Updating the policy to 'Administrators'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeBatchLogonRight = ).*', '*S-1-5-32-544'

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Log on as a batch job' policy is now configured to 'Administrators'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

