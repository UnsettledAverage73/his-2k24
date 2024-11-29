# Title: Remediation Script for 'Generate security audits' Policy
# Description: This script sets the 'Generate security audits' policy to 'LOCAL SERVICE, NETWORK SERVICE' as per CIS recommendations.

Write-Host "Starting Remediation: Configuring 'Generate security audits' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Generate security audits' to LOCAL SERVICE, NETWORK SERVICE
    Write-Host "Updating the policy to 'LOCAL SERVICE, NETWORK SERVICE'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeAuditPrivilege = ).*', '*S-1-5-19,*S-1-5-20'

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Generate security audits' policy is now configured to 'LOCAL SERVICE, NETWORK SERVICE'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

