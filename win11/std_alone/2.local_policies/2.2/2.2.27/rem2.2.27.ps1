# Title: Remediation Script for 'Lock pages in memory' Policy
# Description: This script sets the 'Lock pages in memory' policy to 'No One' as per CIS recommendations.

Write-Host "Starting Remediation: Configuring 'Lock pages in memory' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Lock pages in memory' to the expected value
    Write-Host "Updating the policy to 'No One'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeLockMemoryPrivilege = ).*', ''

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Lock pages in memory' policy is now configured to 'No One'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

