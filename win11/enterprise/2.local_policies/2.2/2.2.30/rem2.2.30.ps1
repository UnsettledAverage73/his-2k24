# Title: Remediation Script for 'Manage auditing and security log' Policy
# Description: This script sets the 'Manage auditing and security log' policy to 'Administrators'.

Write-Host "Starting Remediation: Configuring 'Manage auditing and security log' policy" -ForegroundColor Yellow

try {
    # Export the current security policy configuration
    Write-Host "Exporting current security policy..." -ForegroundColor Cyan
    secedit /export /cfg "$env:TEMP\secedit-output.inf"

    # Load the exported policy configuration
    Write-Host "Reading exported policy configuration..." -ForegroundColor Cyan
    $policyContent = Get-Content "$env:TEMP\secedit-output.inf"

    # Update the policy for 'Manage auditing and security log'
    Write-Host "Updating the policy for 'Manage auditing and security log'..." -ForegroundColor Cyan
    $updatedContent = $policyContent -replace '(?<=SeSecurityPrivilege = ).*', "*S-1-5-32-544"  # Administrators group SID

    # Save the updated policy
    Write-Host "Saving the updated policy configuration..." -ForegroundColor Cyan
    $updatedContent | Set-Content "$env:TEMP\secedit-updated.inf"

    # Apply the updated policy configuration
    Write-Host "Applying the updated security policy..." -ForegroundColor Cyan
    secedit /configure /db secedit.sdb /cfg "$env:TEMP\secedit-updated.inf" /areas USER_RIGHTS

    Write-Host "SUCCESS: 'Manage auditing and security log' policy is now set to 'Administrators'." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to configure the policy. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

